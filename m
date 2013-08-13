Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab3HMNSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:18:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:49370 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757640Ab3HMNSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:18:02 -0400
Message-ID: <520A3206.5080505@linutronix.de>
Date: Tue, 13 Aug 2013 15:17:58 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Bin Liu <binmlist@gmail.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Subject: Re: [PATCH] usb: musb: am335x: Do not remove the session bin HOST-only
 mode
References: <51F2BE6F.3010008@linutronix.de> <CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com> <51F2D427.7050106@linutronix.de> <CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com> <51F2DD90.2030405@linutronix.de> <CADYTM3Y18yo7S6=k6rgFgpPdbZSH4-92q2FmEnWgjxmQ5g2jbA@mail.gmail.com> <20130729165329.GA5773@linutronix.de> <CADYTM3b9MFPM4iDpe3H1uKC1ZCawrQCebqrZikXxS-s9VNDgpw@mail.gmail.com> <51F6ABA2.7060102@linutronix.de> <CADYTM3bcCoWKE9eR5Sd9MbaEUr4G=k=r6JKR+8KC=W_YrbMs3g@mail.gmail.com> <20130809160339.GA14829@linutronix.de> <5205516D.1030707@cogentembedded.com> <5209DCB9.8020705@linutronix.de> <CADYTM3a2M-X=eqz0LmSq4T9UF9khsTGB5TTYWWMRZWwkpRuRTQ@mail.gmail.com>
In-Reply-To: <CADYTM3a2M-X=eqz0LmSq4T9UF9khsTGB5TTYWWMRZWwkpRuRTQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 03:03 PM, Bin Liu wrote:
> Sebastian,

Hi Bin,

>>>> +    if (musb->port_mode == MUSB_PORT_MODE_HOST) {
>>>> +        val = USBMODE_IDDIG_A;
>>>> +        val |= USBMODE_ID_MUX_REG;
>>>
> I am going to so some tests today for this. I don't object to use the
> mode register, but am wondering why we have to play with it for
> host-only mode. The ID pin is grounded for host-only mode, which
> should cause the same as setting mode register.

I've been looking at the wiki page and it did not mention the ID pin
for the second port. If it is grounded then this piece can be removed
and the magic trick is just to skip the try_idle() call.

I haven't found anything saying that it is required to clear the
session bin in host mode, only in OTG. And then, I would assume to
receive a session interrupt once we have the proper VBUS level which
does not happen.

> -Bin.

Sebastian
