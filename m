Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaIWHL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:11:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaIWHL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:11:57 -0400
Date: Tue, 23 Sep 2014 00:11:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: hch@infradead.org, bruce.lucas@mongodb.com,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mptfusion: enable no_write_same for vmware scsi disks
Message-ID: <20140923071154.GB3867@infradead.org>
References: <20140922181929.GA11319@infradead.org>
 <1411418701-25025-1-git-send-email-chris.j.arges@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411418701-25025-1-git-send-email-chris.j.arges@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

thanks for updating it, althugh it would need a few more updates.

> +	/* Fix for vmware guests that do not implement write_same
> +         */
> +	if (pdev->subsystem_vendor == 0x15AD) {
> +		mptspi_driver_template.no_write_same = 1;
> +	}
> +

We should set it only on th host that matches, not the whole template
for this case.  The host is allocated just below your statement in
the same function, so this should be easy.

Also no need for braces here, and try to follow the Linux comment style:

	/* The VMWare emulation doesn't properly impement WRITE SAME */
	if (pdev->subsystem_vendor == 0x15AD)
		sh->no_write_same = 1;
		

(and yes, it would be good to have PCI_VENDOR_ID_VMWARE in pci_ids.h,
 but that shouldn't be done in this bug fix patch)
