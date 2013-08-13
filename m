Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab3HMOXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:23:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:49834 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663Ab3HMOXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:23:09 -0400
Message-ID: <520A414A.1000102@linutronix.de>
Date: Tue, 13 Aug 2013 16:23:06 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Bin Liu <binmlist@gmail.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Subject: Re: [PATCH] usb: musb: am335x: Do not remove the session bin HOST-only
 mode
References: <51F2BE6F.3010008@linutronix.de> <CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com> <51F2D427.7050106@linutronix.de> <CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com> <51F2DD90.2030405@linutronix.de> <CADYTM3Y18yo7S6=k6rgFgpPdbZSH4-92q2FmEnWgjxmQ5g2jbA@mail.gmail.com> <20130729165329.GA5773@linutronix.de> <CADYTM3b9MFPM4iDpe3H1uKC1ZCawrQCebqrZikXxS-s9VNDgpw@mail.gmail.com> <51F6ABA2.7060102@linutronix.de> <CADYTM3bcCoWKE9eR5Sd9MbaEUr4G=k=r6JKR+8KC=W_YrbMs3g@mail.gmail.com> <20130809160339.GA14829@linutronix.de> <5205516D.1030707@cogentembedded.com> <5209DCB9.8020705@linutronix.de> <CADYTM3a2M-X=eqz0LmSq4T9UF9khsTGB5TTYWWMRZWwkpRuRTQ@mail.gmail.com> <520A3206.5080505@linutronix.de> <CADYTM3YU=xt-YDaoOqothjAv_rdnzRmop10Rf7PSA7POaE5DBQ@mail.gmail.com> <520A3847.4090506@linutronix.de> <CADYTM3YDmBw2Due5boftM_a+U2EcVaw8d9sFo8167Q0v1KSRgQ@mail.gmail.com>
In-Reply-To: <CADYTM3YDmBw2Due5boftM_a+U2EcVaw8d9sFo8167Q0v1KSRgQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 04:01 PM, Bin Liu wrote:
> Sebastian,

Hi Bin,

> On Tue, Aug 13, 2013 at 8:44 AM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
>> This was a misunderstanding then. Sorry. I understood that the bin has
>> to be unset and then the controller set it once a device there.
> You meant ID pin? I think it should be set all the time since the
> driver initialized for host-only mode, if it is unset, the controller
> has not way to know if a device is plugged or not.

Okay.

>>> I am not sure if anywhere mentioned about the ID pin, but ASAIK all
>>> the different boards using am335x have ID pin grounded for host port.
>> evm is the only I am aware of. The evm-sk and beagle bone have just one
>> port. Beagle bone black is not mainline.
> You meant the dts only supports one port for evm-sk and bone? The
> boards physically have two ports, usb0 is device only, usb1 is host
> only.

Where is my memory going? So now I have a beagle bone in front of me
and I see a micro USB port a standard A connector. My memory was
different.
The micro USB is the UART and standard is most likely the first musb
instance. So this should run also in host mode and not in OTG mode.
Hmmm. Let me double check this.

>> This is the case already. From musb_start()
>> …
>>         if (musb->port_mode != MUSB_PORT_MODE_HOST &&
>>              (devctl & MUSB_DEVCTL_VBUS) == MUSB_DEVCTL_VBUS) {
>>                  musb->is_active = 1;
>>          } else {
>>                  devctl |= MUSB_DEVCTL_SESSION;
>>          }
>> …
> great! then the host port on gp evm should work now, right?

With the change where don't can try_idle() in host mode, yes.

> 
>>
>>>>> -Bin.

Sebastian
