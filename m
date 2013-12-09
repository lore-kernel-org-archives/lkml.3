Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab3LIMJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 07:09:26 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:45289 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643Ab3LIMJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 07:09:24 -0500
Message-ID: <1386590958.7152.135.camel@host5.omatika.ru>
Subject: Re: [PATCH 5/9] ARM: dts: provide DMA config to pxamci
From: Sergei Ianovich <ynvich@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
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
Date: Mon, 09 Dec 2013 16:09:18 +0400
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
> > Nice to have Daniel in this conversation. Your patch series is a big and
> > important work. However, I am not sure I will ever land as is exactly
> > for this reason.
> 
> Well, I wouldn't be so certain about that statement. As I wrote in the
> cover letter, most of the work is actually done, and I successfully
> tested the new DMA support with a some of the drivers I ported. Others
> were ported blindly, and in case of no reaction, I'd dare to merge them
> and wait for people to report back in case of trouble.

If breaking things is an option, I am definitely wrong. I assumed the
opposite.

> > My proposal in to actually add new drivers for each platform device with
> > DMA and mark new ones EXPERIMENTAL.
> 
> That would cause tree-wide cross-dependencies between drivers, because
> the two DMA controllers can't be used at the same time, and the PXA
> specific API will be unavailable when the mmp-dma driver is selected. My
> patch series (and the DMA controller framework for that matter) aims for
> the opposite - the unification of APIs and drivers.

Not sure I got this point. My proposal is to keep the existing DMA
intact until we are ready to remove it. I understand this approach
requires considerably more work inside DMA to allow both driver to
coexist than wholesale replacement. I still think big change is risky.

