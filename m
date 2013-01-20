Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3ATLkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 06:40:15 -0500
Received: from 8bytes.org ([85.214.48.195]:40968 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab3ATLkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 06:40:13 -0500
Date: Sun, 20 Jan 2013 12:40:11 +0100
From: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Message-ID: <20130120114011.GN25591@8bytes.org>
References: <50FBC7EF.6040207@xs4all.nl>
 <20130120103652.GB16800@pd.tnic>
 <50FBC994.8020409@xs4all.nl>
 <20130120111920.GL25591@8bytes.org>
 <50FBD413.1000406@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50FBD413.1000406@xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Jan 20 12:40:11 2013
X-DSPAM-Confidence: 0.9971
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50fbd79b22971683758648
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 12:25:07PM +0100, Udo van den Heuvel wrote:
> Hello Jörg,
> 
> Hardware issue? What is wrong c.q. happening?

I think it falls under Erratum 455 (which does not mention IOMMU
specifically). Point is, there is a hardware workaround for this to make
the IOMMU work, but your BIOS does not enable it.

> 
> I have this:
> 
> # dmesg|grep IOMMU
> [    0.000000] ACPI: IVRS 000000009dd12420 00070 (v02  AMD   AMDIOMMU
> 00000001 AMD  00000000)
> [    0.000000] Please enable the IOMMU option in the BIOS setup
> [    1.125636] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
> 
> So kernel says I have no IOMMU but still one is found? (!?)

The "Please enable IOMMU ..." line tells you about the GART, not the AMD
IOMMU. This is a frequent source of confusion, we probably should remove
that line. Trinity has no GART, so there is nothing to find :)

> In PC-BIOS I assume?
> I did not yet find an option, but this is the first occurrence.
> Can the BIOS vendor fix this? If so: please explain so I cna contact
> Gigabyte (motherboard manufacturer)

Yes, the BIOS vendor can fix this issue. They need to disable NB clock
gating for the IOMMU.

> What is the impact of disabling the IOMMU?

Well, it has some security impact and if you have more than 4GB of RAM
maybe also some slight performance impact due to DMA bounce buffering.
But thats still better as a system that stops working after some time.


	Joerg


