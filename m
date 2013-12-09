Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700Ab3LINQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:16:45 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:54738 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab3LINQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:16:43 -0500
Message-ID: <1386594997.7152.164.camel@host5.omatika.ru>
Subject: Re: [PATCH 5/9] ARM: dts: provide DMA config to pxamci
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Mack <zonque@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        DOCUMENTATION <linux-doc@vger.kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 09 Dec 2013 17:16:37 +0400
In-Reply-To: <52A59991.1060305@gmail.com>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
		 <1386543229-1542-1-git-send-email-ynvich@gmail.com>
		 <1386543229-1542-6-git-send-email-ynvich@gmail.com>
		 <201312090233.58592.arnd@arndb.de> <52A587A0.1050503@gmail.com>
	 <1386581672.7152.108.camel@host5.omatika.ru> <52A59991.1060305@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 11:21 +0100, Daniel Mack wrote:
> On 12/09/2013 10:34 AM, Sergei Ianovich wrote:
> > On Mon, 2013-12-09 at 10:04 +0100, Daniel Mack wrote:
> >> On 12/09/2013 02:33 AM, Arnd Bergmann wrote:
> >>> It hasn't made it upstream yet, but see http://list-archives.org/2013/08/07/linux-mtd-lists-infradead-org/patch-00-20-arm-pxa-move-core-and-drivers-to-dmaengine/f/3444199144
> >>> for how it's done. Maybe Daniel can comment on the status of his
> >>> patches.
> >>
...
> The only real problem is the PXA camera driver, which does tricky things
> like hot re-queuing of DMA descriptors. That one needs fixing before the
> series can land.

My impression is that his series is hard to land. I've expressed my
concerns about big changes in a separate mail.

PXA device tree support issue is practically orthogonal. As of August
2013, Daniel's dma series doesn't add any dt support. After new DMA is
working, we will need to add dt support in the same drivers.

Basically we have three options:
A. Wait for Daniel DMA, than for PXA clock, than do dt support
 pros: 
 * correct order
 cons:
 * need to wait, possibly a long time
 * dt boot not possible, while we wait

B. Provide 'hackish' support to dt, than correct hacks when DMA is
merged.
 pros:
 * parallel development
 * healthier kernel code (current PXA usb driver won't compile with dt
enabled)
 cons:
 * wrong concept (like my patch 5/9) until DMA is working
 * need to recompile dtb files when kernel changes

C. Use 'fake' DMA provider dt binding to emulate existing DMA until new
DMA is merged, than 
 pros:
 * parallel development
 * healthier kernel code
 * correct device trees from the beginning
 cons:
 * more work
 * still need to recompile dtbs when clock support is merged

Any ideas?

