Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbaHZXyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 19:54:35 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:60496 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbaHZXye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 19:54:34 -0400
Message-ID: <53FD1E1A.6020404@gmail.com>
Date: Tue, 26 Aug 2014 16:54:02 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] genirq: bug on inconstent flags and flow handler
References: <1406141136-19501-1-git-send-email-f.fainelli@gmail.com>	<alpine.DEB.2.10.1407232048240.23352@nanos> <CAGVrzcbMKOGV20OGWY9n7xw3f=6+oyRvza+qRbCHfbVECmTLNQ@mail.gmail.com>
In-Reply-To: <CAGVrzcbMKOGV20OGWY9n7xw3f=6+oyRvza+qRbCHfbVECmTLNQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 12:14 PM, Florian Fainelli wrote:
> 2014-07-23 11:49 GMT-07:00 Thomas Gleixner <tglx@linutronix.de>:
>> On Wed, 23 Jul 2014, Florian Fainelli wrote:
>>
>>> It is currently possible for a generic irq chip driver to set IRQ_LEVEL
>>> and have its irq flow handler be handle_edge_irq. Setting IRQ_LEVEL in
>>> such a case does not make sense, and will actually prevent e.g: the
>>> software resend logic from kicking, and potential other problems too.
>>>
>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>> ---
>>> Changes in v2:
>>> - replaced WARN_ON() with BUG_ON() since we really don't want to continue
>>>   as suggested by Jason Cooper
>>
>> I disagree here. It's not a reason take the machine down. Its good
>> enough to WARN. That keeps the machine alive and lets us debug that
>> stuff.
> 
> Works for me!
> 
>>
>> Lemme find V1 ....
> 
> Here it is: https://lkml.org/lkml/2014/7/1/468

Thomas, do you want me to resubmit that change so you get a clean
submission in your inbox? Thanks
--
Florian
