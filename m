Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761744Ab3EDSNF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 14:13:05 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18513 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756831Ab3EDSNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 14:13:02 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/iDG3JF9ipzmYnwqvN1U0qaLHVQAt7tIA=
Date: Sat, 4 May 2013 14:12:27 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
Message-ID: <20130504181227.GN31290@titan.lakedaemon.net>
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <alpine.LFD.2.02.1305022324371.2891@ionos>
 <5182E11E.5010103@gmail.com>
 <201305030009.57041.arnd@arndb.de>
 <5182EAA0.9070208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5182EAA0.9070208@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 12:37:20AM +0200, Sebastian Hesselbarth wrote:
> (@Jason C: Are you sure that I should merge dove and orion
> irqchip patches? I doubt that anything touching generic irq
> will not go through irq tree.)

Putting them in the same patch series does not imply they have to go
through the same tree.  But it *does* allow us to see relationships,
conflicts, etc.

Based on how the finally dependencies work out, we may ask the irq
maintainers for an Ack to take it through arm-soc.  This would happen if
we can't remove the dependency between the trees.  The resulting
potential merge conflicts weigh into it, and that's where the irqchip
maintainer's Ack get decided.

If the changes to irqchip are just Makefile/Kconfig, then it's easy.
However, if several other files are changed and conflicting, then we let
it go through irqchip and wait one merge window for the board changes
depending on it.

The goal here is to identify and remove branch dependencies within
arm-soc and between arm-soc and other trees.  A secondary goal is to
identify high-risk series (risk of being dropped), and keep them
in separate branches from other changes.

thx,

Jason.
