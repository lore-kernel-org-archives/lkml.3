Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaKYJro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 04:47:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaKYJrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 04:47:43 -0500
Message-ID: <5474503D.5030501@suse.de>
Date: Tue, 25 Nov 2014 10:47:41 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org
CC: Christoph Hellwig <hch@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] wd719x: Add firmware documentation
References: <1416867882-29344-1-git-send-email-linux@rainbow-software.org> <1416867882-29344-4-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1416867882-29344-4-git-send-email-linux@rainbow-software.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 11:24 PM, Ondrej Zary wrote:
> Add documentation and script to obtain required firmware.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  Documentation/scsi/wd719x.txt |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 Documentation/scsi/wd719x.txt
> 
> diff --git a/Documentation/scsi/wd719x.txt b/Documentation/scsi/wd719x.txt
> new file mode 100644
> index 0000000..0816b02
> --- /dev/null
> +++ b/Documentation/scsi/wd719x.txt
> @@ -0,0 +1,21 @@
> +Driver for Western Digital WD7193, WD7197 and WD7296 SCSI cards
> +---------------------------------------------------------------
> +
> +The card requires firmware that can be cut out of the Windows NT driver that
> +can be downloaded from WD at:
> +http://support.wdc.com/product/download.asp?groupid=801&sid=27&lang=en
> +
> +There is no license anywhere in the file or on the page - so the firmware
> +probably cannot be added to linux-firmware.
> +
> +This script downloads and extracts the firmware, creating wd719x-risc.bin and
> +d719x-wcs.bin files. Put them in /lib/firmware/.
> +
> +#!/bin/sh
> +wget http://support.wdc.com/download/archive/pciscsi.exe
> +lha xi pciscsi.exe pci-scsi.exe
> +lha xi pci-scsi.exe nt/wd7296a.sys
> +rm pci-scsi.exe
> +dd if=wd7296a.sys of=wd719x-risc.bin bs=1 skip=5760 count=14336
> +dd if=wd7296a.sys of=wd719x-wcs.bin bs=1 skip=20096 count=514
> +rm wd7296a.sys
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 21284 (AG Nürnberg)
