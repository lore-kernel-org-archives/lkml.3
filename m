Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936476Ab3DKBNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 21:13:20 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28624 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934997Ab3DKBNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 21:13:19 -0400
X-Spam-Score: -100.8
Message-ID: <51660E0D.7030205@asianux.com>
Date: Thu, 11 Apr 2013 09:12:45 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: auditfilter: looping issue, memory leak if has
 2 or more AUDIT_FILTERKEYs
References: <51653645.90401@asianux.com> <51653C7A.6030405@asianux.com> <51653EC2.5030107@asianux.com> <516540CB.7090301@asianux.com> <1145090153.12320456.1365629897666.JavaMail.root@redhat.com>
In-Reply-To: <1145090153.12320456.1365629897666.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月11日 05:38, Eric Paris wrote:
> ----- Original Message -----
>> > 
>> >   also for function audit_list_rules:
>> >     when call audit_make_reply fails (will return NULL).
>> >     we also need process data->buf, not only data itself.
>> > 
>> >   please help check, thanks.
> struct audit_rule_data {
> [...]
>         char            buf[0]; /* string fields buffer */
> };
> 
> The last element in the struct is 0 length.  But the allocation in audit_krule_to_data() looks like:
> 
> data = kmalloc(sizeof(*data) + krule->buflen, GFP_KERNEL);
> 
> So now data->buf appears as an allocation of size krule->buflen.
> 
> We do not need to free it separately.  This is a pretty common C trick.

  ok, thanks

  it is my fault.

  :-)

-- 
Chen Gang

Asianux Corporation
