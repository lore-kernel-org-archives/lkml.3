Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbaCZROD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:14:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36703 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaCZRN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:13:57 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-fb-53330a959f8b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Tejun Heo <tj@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: fix Marvell SATA driver dependencies
Date: Wed, 26 Mar 2014 18:12:31 +0100
Message-id: <4852939.9jMb8Bv2x2@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140326165904.70de238d@alan.etchedpixels.co.uk>
References: <5138028.BSQbEP7RRB@amdc1032> <20140326162302.GG25349@lunn.ch>
 <20140326165904.70de238d@alan.etchedpixels.co.uk>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=US-ASCII
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t9jQd2pXMbBBp9maVmcv3uI2WLSlL9s
	Fpva3jJaNC65zGKx6fE1VotjOx4xWVzeNYfN4v1PR4tfy48yOnB6PNl0kdFj56y77B6bVnWy
	eTQcOM/isXlJvcfOHZ+ZPFpPbmL1+LxJLoAjissmJTUnsyy1SN8ugStj50r2gkbuig3nZrI3
	MF7m6GLk5JAQMJFYcvUeE4QtJnHh3nq2LkYuDiGB6YwSR7ufs0I4LUwS7W33WEGq2ASsJCa2
	r2IEsUWAuptfvWYEKWIW2MEkse3FexaQhLCAncS96VPBGlgEVCXW7OoGWsHBwSugKfHgoiRI
	WFTAU2LH9pVsIDYnUPm3aS1grUICdRK977eD2bwCghI/Jt8Ds5kF5CX27YcYySygJbF5WxPr
	BEaBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Jh4JrWDcWWDxSFG
	AQ5GJR7eHfeNgoVYE8uKK3MPMUpwMCuJ8O74ChTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6DV
	OlBIID2xJDU7NbUgtQgmy8TBKdXAuK10tquv9GNRw5DWJ67VWfvNnCvT/GJWln9N/r9ksgTb
	VPtO6f/P2OPSez8HqizRy/mRkibYIjX11QamhNwFq+pn71lomG6Tv/xbZJK+3l2DDwlZ/2Yf
	vth5ev6HYgO5JCuHnou96QWh59fqrfl/90Jm78Kc+z+Oa1YqbEpJtn8V7brVSu6aEktxRqKh
	FnNRcSIAtorfBYUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, March 26, 2014 04:59:04 PM One Thousand Gnomes wrote:
> On Wed, 26 Mar 2014 17:23:02 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Wed, Mar 26, 2014 at 05:19:02PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > Make sata_mv host driver depend on PCI || ARCH_KIRKWOOD || ARCH_MVEBU ||
> > > ARCH_ORION5X config options as Marvell SATA support covers both Marvell
> > > PCI devices and Marvell Kirkwood, Armada 370/XP and Orion5x SoCs (for
> > > non-PCI devices the driver to work requires suitable device tree node to
> > > be defined).  Additionally allow the driver build if COMPILE_TEST config
> > > option is set.
> > 
> > Hi Bartlomiej
> > 
> > I _think_ there are a few powerpc platforms which can also make use of
> > this driver
> 
> The hardware can show up in just about anything so I think this patch
> should be dropped

In theory maybe but in practice it for sure won't show up if the vendor
has its own SATA solution and at least in the ARM world it seems frequent
to have its own AHCI variant nowadays.  Moreover even if the new usage
shows up it is not enough to enable driver for it to make it work as
you also need to add a node describing your SATA MV variant to your SoC
device tree file (which requires updating kernel source anyway).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

