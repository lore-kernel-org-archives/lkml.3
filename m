Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821Ab3DKDoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:44:06 -0400
Received: from intranet.asianux.com ([58.214.24.6]:22137 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759688Ab3DKDoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:44:04 -0400
X-Spam-Score: -100.8
Message-ID: <51663161.9070300@asianux.com>
Date: Thu, 11 Apr 2013 11:43:29 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: auditfilter: looping issue, memory leak if has
 2 or more AUDIT_FILTERKEYs
References: <51653645.90401@asianux.com> <51653C7A.6030405@asianux.com> <51653EC2.5030107@asianux.com> <803399362.12318964.1365629578422.JavaMail.root@redhat.com>
In-Reply-To: <803399362.12318964.1365629578422.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月11日 05:32, Eric Paris wrote:
> ----- Original Message -----
>> > 
>> >   also for function audit_list:
>> >     when call audit_make_reply fails (will return NULL).
>> >     we need free all its related variables instead of only kfree rull.
>> >       (such as call autit_free_rule)
>> > 
>> >   please help check, thanks.
> audit_free_rule() takes a struct audit_entry, not an audit_rule. 

  yes. but maybe you misunderstand what I said (excuse me, my English is
not quite weill)
  I said: "need we process the rule just like audit_free_rule has done ?"


> struct audit_rule does not have additional things which need to be freed...
> 
> 

  oh, it is my fault:
    (I did not notice: rule is struct audit_rule, not struct audit_krule).

  thanks.

  :-)

-- 
Chen Gang

Asianux Corporation
