Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab3F1SoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:44:11 -0400
Received: from mout0.freenet.de ([195.4.92.90]:35910 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340Ab3F1SoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:44:07 -0400
Message-ID: <51CDD8FD.808@01019freenet.de>
Date: Fri, 28 Jun 2013 20:42:05 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0 SeaMonkey/2.17
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Alex Williamson <alex.williamson@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ 102/127] iommu/amd: Workaround for ERBT1312
References: <lhtAZ-q1-5@gated-at.bofh.it> <lhtB1-q1-53@gated-at.bofh.it> <20130628181136.52d00e9c@dualc.maya.org> <20130628182533.GT11309@8bytes.org>
In-Reply-To: <20130628182533.GT11309@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joerg,

Joerg Roedel wrote:
> Hi Andreas,
> 
> On Fri, Jun 28, 2013 at 06:11:36PM +0200, Andreas Hartmann wrote:
>> Hello Joerg, hello Alex,
>>
>> the subsequent patch and the patch "iommu/amd: Re-enable IOMMU event log
>> interrupt after handling." 925fe08bce38d1ff052fe2209b9e2b8d5fbb7f98
>> spread /var/log/messages with the following line (> 700 lines/second)
>> right after loading vfio:
>>
>> AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.0 domain=0x0000 address=0x000000fdf9103300 flags=0x0600]
>>
>> lspci -vvvs 0:14.0
>> 00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus Controller (rev 42)
>>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>>         Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
> Most likely a BIOS issue that is uncovered by re-enabling the event-log
> interrupt patch. The device itself is only used by the BIOS and not by
> the Linux kernel

Thanks for this info! Good to know.

[...]

>> I removed the two mentioned patches and all is working
>> fine again as before.
> 
> Without these two patches, can you check dmesg after boot if there are
> other lines which report IO_PAGE_FAULTs?

You're right, there is exactly one entry directly after loading of vfio.
I can see this message, too, with linux 3.4.43.


Regards,
Andreas
