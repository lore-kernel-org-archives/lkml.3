Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbaBZKrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:47:48 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53020 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbaBZKrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:47:46 -0500
Date: Wed, 26 Feb 2014 10:47:02 +0000
From: Will Deacon <will.deacon@arm.com>
To: Marc Carino <marc.ceeeee@gmail.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH v7 5/9] ARM: Enable erratum 798181 for Broadcom Brahma-B15
Message-ID: <20140226104702.GA8961@mudshark.cambridge.arm.com>
References: <1393410552-21497-1-git-send-email-marc.ceeeee@gmail.com>
 <1393410552-21497-6-git-send-email-marc.ceeeee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393410552-21497-6-git-send-email-marc.ceeeee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 10:29:08AM +0000, Marc Carino wrote:
> From: Gregory Fong <gregory.0xf0@gmail.com>
> 
> Broadcom Brahma-B15 (r0p0..r0p2) is also affected by Cortex-A15
> erratum 798181, so enable the workaround for Brahma-B15.

Really... *exactly* the same erratum? That sounds pretty unlikely, so I'd
really like to be sure that the workaround we have indeed solves your
problem (issuing a dummy TLBI to 0x0 + dsb, then followed by a dmb + clrex
on each core). The point is that the workaround doesn't simply perform
non-shareable invalidation on each core using IPIs.

/me counts the days until we need this code in arch/arm64.

Will
