Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761928Ab3EBTMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:12:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61627 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760667Ab3EBTMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:12:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
Date: Thu, 2 May 2013 21:11:40 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        "Jean-Francois Moine" <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130502185322.GA29333@obsidianresearch.com>
In-Reply-To: <20130502185322.GA29333@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305022111.41043.arnd@arndb.de>
X-Provags-ID: V02:K0:ZFKhDFAx7OSUgMbUOdvWUiLLc2kDkCfy5G57qXiSzYk
 R/y8+pUJPBm52kBFDgMgqsgxIoEZl9xX+d2BDquE0b7LRnyyne
 kNRGs00v7zjuCEc1qdkdCELZH0IXL/X5LUPycFXPB1Pqvtpid7
 E3pH5db19qbHi6FTYJI/H9+27nvrm8ByJw+bgVSS/df9OjS5X4
 F9R7q30zreHQ7+8WnAoVM6lqLPVaUJ3Ghw9SYFvzHh7Wi7enaf
 sxJOmJ3ruwtX1M8hAZQwradeHD/lG1AX+7cxq53TIR6CUtuCVp
 tyOHKJp768gPtgl6WvPOGu8pIghuqVGYiRgCG9KVzT3DnNTdfr
 G1rNbf+rUiok23jWDuIs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 May 2013, Jason Gunthorpe wrote:
> > +static struct of_device_id orion_irq_dt_ids[] __initconst = {
> > +     { .compatible = "marvell,orion-mpic", .data = orion_of_init },
> > +     { }
> 
> Is there a strong reason to change the compatible string? Looks to me
> like either the new driver or the old driver will bind depending on
> what is in the machine description. No need for a new string?
> 

The compatible string should change if the binding changes in an
incomptible way, and we should try not to change it unless it's
fundamentally flawed.

	Arnd
