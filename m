Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaE1L0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:26:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaE1L0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:26:30 -0400
Date: Wed, 28 May 2014 04:26:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt2sas: mpt2sas_base.c:  Fix for possible null
 pointer dereference
Message-ID: <20140528112628.GB11953@infradead.org>
References: <1400429439-11184-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400429439-11184-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
> +	if (mpi_reply) {
> +		ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
> +	}
>  
>  	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
>  		ioc->port_enable_failed = 1;

ioc_status isn't initialized without the reply and used here as well
as later in the function.  I think we'll need input from LSI or others
with the spec on what to do when we didn't get a reply.

