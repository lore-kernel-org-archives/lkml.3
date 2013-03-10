Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab3CJNLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:11:54 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:15156 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3CJNLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:11:53 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzIuKuS8A==
X-RZG-CLASS-ID: mo00
Message-ID: <513C8694.9090003@hartkopp.net>
Date: Sun, 10 Mar 2013 14:11:48 +0100
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: Valentin Ilie <valentin.ilie@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: can: af_can.c: Fix checkpatch warnings
References: <1362918526-26730-1-git-send-email-valentin.ilie@gmail.com> <513C8062.6030001@hartkopp.net> <CACTFLAM4DtRGvEFQo5yXhR4Sjx8hKBJoNqARqA5U+9iQK=gkBg@mail.gmail.com>
In-Reply-To: <CACTFLAM4DtRGvEFQo5yXhR4Sjx8hKBJoNqARqA5U+9iQK=gkBg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.03.2013 14:05, Daniel Mack wrote:


>>> @@ -817,8 +817,7 @@ static int can_notifier(struct notifier_block *nb, unsigned long msg,
>>>               /* create new dev_rcv_lists for this device */
>>>               d = kzalloc(sizeof(*d), GFP_KERNEL);
>>>               if (!d) {
>>> -                     printk(KERN_ERR
>>> -                            "can: allocation of receive list failed\n");
>>> +                     pr_err("can: allocation of receive list failed\n");
>>>                       return NOTIFY_DONE;
>>>               }
>>
>>
>> As i've seen in former patches from Joe Perches OOM messages are obsolete.
>>
>> You could write
>>
>> if(!d)
>>         return NOTIFY_DONE;
>>
>> here instead.
> 
> While at it, why not switch to dev_err() instead?


Hm, no.

1. pr_err() would be fine, as dev_err() is for drivers - and we're in
linux/net here and not in linux/drivers

2. When removing the entire printk() statement there's nothing to be modified left

Regards,
Oliver

