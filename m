Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaACOfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 09:35:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52413 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaACOfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 09:35:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 01/17] ARM: spear: Remove deprecated IRQF_DISABLED flag
Date: Fri, 3 Jan 2014 15:34:37 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, khilman@linaro.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        patches@linaro.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
References: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org> <201401021929.46581.arnd@arndb.de> <52C5B52E.6080609@linaro.org>
In-Reply-To: <52C5B52E.6080609@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401031534.37533.arnd@arndb.de>
X-Provags-ID: V02:K0:J0LLZ8ezz1HuyW+POrTOfMakWL3fUo5GITDf/fe6zw3
 tGgELNdo02pA8plSlibm02QFkPELP6cqPFgtLekhL+mcUAHyga
 aQbHXfEvkKJYHFLmzYW9aa82bQAF1IZvaXDch4o1khBMY1nzXS
 p0TbMaj9X4ncb4aSTj9bdXWpLmxJpLxcZRZ18lmpkjNvc1vCn7
 jCvZvY4wROhyTdntkDwpZlgI171bhFuIFY0FIombIBhS7hw83n
 mgp6Ie8XU8Fd5I+23NZi4l9oV5XnEWnxM4ujttReBNzR61XZDY
 q8juN6fpU4DVSvPJWeotjRYeRM5c/QFpivzbk35uoXj+GmfkTl
 asePrNXQFBwHMGJY0Vok=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 January 2014, Daniel Lezcano wrote:
> On 01/02/2014 07:29 PM, Arnd Bergmann wrote:
> > On Monday 30 December 2013, Daniel Lezcano wrote:
> >> This flag is a NOOP and scheduled to be removed
> >>
> >> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> >
> > Thanks for sending this series. I think the patches are duplicates of stuff that
> > Michael Opdenacker has sent before (actually multiple times). I have no problem
> > applying either version into arm-soc, but I think it would be better to attribute
> > them to Michael, since he came first. Can you two please coordinate and send a
> > single pull request for the arm-soc related patches that haven't made it into
> > linux-next yet?
> 
> Michael removed the flag for:
> 
> pxa (ed7936f913456e4c01aed75deba6cfaf830fa8cf)
> samsung (fa53d5cdbffbce421c3bd2f937b5626fc044fedc)
> avr32 (7155530d9eb692994d208836e4965da06b17c99d)
> ep93xx (3a71ae4796fdaedbdbdab94660b7b7b5bfe61d1d)
> plat-orion (eb4d552b933ac59c0c8e0604ff435c5208a82679)
> 
> The patchset I sent is on top of arm/for-next and finishes to remove 
> this flag for arch/arm. It should not overlap with what Michael did.
> 
> I'm ok to attribute the patchset to Michael if that can help to accept 
> this patchset and kill this flag for arch/arm.

IIRC, Michael actually sent patches for all uses in the entire kernel
previously, but relied on sub-maintainers to pick them up one by one.
Some patches already got 'Acked-by' replies, which I'd like to keep.

It's probably time to do a bigger sweeping change now and kill it for
good, bypassing the remaining maintainers that haven't acted so far.
We can certainly carry the patches related to arm-soc, and I think
it's worth trying once more to get the scsi patches merged, since there
is a bunch of them. Everything else can probably go directly as a
single pull-request to Linus, or perhaps via Andrew Morton.

	Arnd
