Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3H0NCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:02:20 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:56247 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab3H0NCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:02:18 -0400
MIME-Version: 1.0
X-Originating-IP: [95.21.192.235]
In-Reply-To: <521C6961.9020103@linutronix.de>
References: <20130827181353.319c150858829df1bb68d60b@canb.auug.org.au>
	<521C6961.9020103@linutronix.de>
Date: Tue, 27 Aug 2013 15:02:16 +0200
Message-ID: <CABxcv=mg6t5wPqpF3j5sr_76qfZ7N7KgpWhcKSGoPTOcaR=V6A@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the usb tree
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, bcousson@baylibre.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-next@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Benoit Cousson (OMAP DT maintainer)]

On Tue, Aug 27, 2013 at 10:54 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> On 08/27/2013 10:13 AM, Stephen Rothwell wrote:
>
>> Today's linux-next merge of the arm-soc tree got a conflict in
>> arch/arm/boot/dts/am335x-bone.dts between commit 97238b35d5bb
>> ("usb: musb: dsps: use proper child nodes") from the  tree and
>> commit 63f6b2550aa0 ("ARM: dts: AM33XX: don't redefine OCP bus and
>> device nodes") from the arm-soc tree.
>>
>> I fixed it up (probably incorrectly - see below) and can carry the
>> fix as necessary (no action is required).
>
> You added the OCP node back and the USB nodes as I had them which
> should be fine.
>
> How do we solve the conflict for the merge window? Is it possible for
> the ARM-SOC tree to create a topic branch for this commit?
>
> Greg: I do have a pending pull / patches [0] which also change the dts
> nodes according to the latest feedback + enabling an additional USB
> port in bone.
> If you take this in I could update the nodes later (with the topic
> branch merged) accordingly to the way it has been done in the ARM-SOC
> tree - unless you have other preferences.
>

I think that the proper way to handle this is to split the patch-set
in two and merge all the OMAP DT related changes
(arch/arm/boot/dts/am*) through Benoit's tree and the USB changes
(drivers/usb/*) through Greg tree to prevent these kind of merge
conflicts.

Thanks a lot and best regards,
Javier

> [0] http://www.spinics.net/lists/linux-usb/msg92595.html
>
> Sebastian
>
