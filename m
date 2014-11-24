Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaKXU4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:56:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:41299 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaKXU4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:56:32 -0500
Message-ID: <54739B7C.7020102@linutronix.de>
Date: Mon, 24 Nov 2014 21:56:28 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>, George Cherian <george.cherian@ti.com>,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is
 fully handled
References: <1415953486-6000-1-git-send-email-george.cherian@ti.com> <20141118211734.GA19146@saruman> <54736FBE.6060505@linutronix.de> <20141124182053.GD25712@saruman> <20141124203908.4425.qmail@stuge.se>
In-Reply-To: <20141124203908.4425.qmail@stuge.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 09:39 PM, Peter Stuge wrote:
> Felipe Balbi wrote:
>>>> A babble only occurs when
>>>> the device side tries to move data without the host asking for anything.
>>>
>>> It also occurs if the device moves more than packet_size bytes. Not
>>> really helping, I know…
>>
>> hmm, why would the device move more than wMaxPacketSize at a time ?
> 
> Some devices are buggy.

for instance if the device comes out of resume and the clock is not yet
stable but the device sends data. That is not the case here, but an
example :)
I *think* for some reason the host did not really receive ep0
set_config request as planned. And device's answer is probably then
interpreted as data which is not expected (as Felipe said "device side
tries to move data without the host asking for anything").

>> That's certainly babble :-)
> 
> Certainly! But musb shouldn't fall over or lock up because of it, should it?

No and the patch fixes the issue. The strange thing is that it only
happens on the same device. Not if you connect host<->device with two
boards.

> //Peter
> 

Sebastian
