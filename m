Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891Ab3DJK2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:28:54 -0400
Received: from intranet.asianux.com ([58.214.24.6]:11362 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3DJK2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:28:53 -0400
X-Spam-Score: -100.8
Message-ID: <51653EC2.5030107@asianux.com>
Date: Wed, 10 Apr 2013 18:28:18 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>, eparis@redhat.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: auditfilter: looping issue, memory leak if has
 2 or more AUDIT_FILTERKEYs
References: <51653645.90401@asianux.com> <51653C7A.6030405@asianux.com>
In-Reply-To: <51653C7A.6030405@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  also for function audit_list:
    when call audit_make_reply fails (will return NULL).
    we need free all its related variables instead of only kfree rull.
      (such as call autit_free_rule)

  please help check, thanks.

  :-)

gchen.

On 2013年04月10日 18:18, Chen Gang wrote:
> 
> 
> in another function: audit_data_to_entry:
> 
>   a. has the same issue for case AUDIT_WATCH.
> 
>   b. has an new issue for AUDIT_DIR:
>        after AUDIT_DIR succeed, it will set rule->tree.
>        next, the other case fail, then will call audit_free_rule.
>        but audit_free_rule will not free rule->tree.
> 
> 
>   I find them only by reading code, not test them.
>   and I also do not know about the related features.
>   so please help check my 2 opinions whether are correct.
> 
> 
>   welcome any suggestion or completions.
> 
>   thanks.
> 
>   :-)
> 
> 
> gchen.
> 
> 
> On 2013年04月10日 17:52, Chen Gang wrote:
>>
>>   in the 'fcount' looping,
>>     if 'new->fields[*].type" has 2 or more AUDIT_FILTERKEYs
>>     need judge new->filterkey whether has value, or memory leak.
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  kernel/auditfilter.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
>> index f9fc54b..936ac79 100644
>> --- a/kernel/auditfilter.c
>> +++ b/kernel/auditfilter.c
>> @@ -859,6 +859,8 @@ struct audit_entry *audit_dupe_rule(struct audit_krule *old)
>>  						       &old->fields[i]);
>>  			break;
>>  		case AUDIT_FILTERKEY:
>> +			if (new->filterkey)
>> +				break;
>>  			fk = kstrdup(old->filterkey, GFP_KERNEL);
>>  			if (unlikely(!fk))
>>  				err = -ENOMEM;
>>
> 
> 


-- 
Chen Gang

Asianux Corporation
