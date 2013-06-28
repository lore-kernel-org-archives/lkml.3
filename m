Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab3F1SZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:25:37 -0400
Received: from 8bytes.org ([85.214.48.195]:47146 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab3F1SZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:25:36 -0400
Date: Fri, 28 Jun 2013 20:25:33 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ 102/127] iommu/amd: Workaround for ERBT1312
Message-ID: <20130628182533.GT11309@8bytes.org>
References: <lhtAZ-q1-5@gated-at.bofh.it>
 <lhtB1-q1-53@gated-at.bofh.it>
 <20130628181136.52d00e9c@dualc.maya.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628181136.52d00e9c@dualc.maya.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jun 28 20:25:34 2013
X-DSPAM-Confidence: 0.9974
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51cdd51e20867625220505
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Fri, Jun 28, 2013 at 06:11:36PM +0200, Andreas Hartmann wrote:
> Hello Joerg, hello Alex,
> 
> the subsequent patch and the patch "iommu/amd: Re-enable IOMMU event log
> interrupt after handling." 925fe08bce38d1ff052fe2209b9e2b8d5fbb7f98
> spread /var/log/messages with the following line (> 700 lines/second)
> right after loading vfio:
> 
> AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.0 domain=0x0000 address=0x000000fdf9103300 flags=0x0600]
> 
> lspci -vvvs 0:14.0
> 00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus Controller (rev 42)
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

Most likely a BIOS issue that is uncovered by re-enabling the event-log
interrupt patch. The device itself is only used by the BIOS and not by
the Linux kernel

> Besides the enormous pollution I couldn't see any malfunction at all.
> At first, I didn't realised it at all (-> the SSD was fast enough to
> cover it silently). I saw it the first time I rebooted because X didn't start any more because
> the /var partition was completely full. 
> 
> I removed the two mentioned patches and all is working
> fine again as before.

Without these two patches, can you check dmesg after boot if there are
other lines which report IO_PAGE_FAULTs?


	Joerg


