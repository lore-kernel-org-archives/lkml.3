Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab3CVLdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:33:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41881 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab3CVLdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:33:45 -0400
Date: Fri, 22 Mar 2013 11:32:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Lior Amsalem <alior@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jon Masters <jcm@redhat.com>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 2/5] arm: mvebu: Select DMA_BOUNCE when LPAE is
	selected in Kconfig
Message-ID: <20130322113251.GB4977@n2100.arm.linux.org.uk>
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com> <1363883179-1361-3-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363883179-1361-3-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 05:26:15PM +0100, Gregory CLEMENT wrote:
> From: Lior Amsalem <alior@marvell.com>
> 
> For mvebu IOs are 32 bits and we have 40 bits memory due to LPAE so
> make sure we give 32 bits addresses to the IOs.
> 
> Signed-off-by: Lior Amsalem <alior@marvell.com>
> Tested-by: Franklin <flin@marvell.com>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Oh god no.  Please move away from the addition on DMABOUNCE - that code
creaks, doesn't have highmem support, and is known to give problems on
various platforms.

Instead, please rely on using the DMA mask and such like, just like on
x86.
