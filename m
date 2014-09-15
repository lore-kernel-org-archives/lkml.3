Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbaIOVXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:23:49 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:49374 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaIOVXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:23:48 -0400
Date: Mon, 15 Sep 2014 22:23:42 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        KY Srinivasan <kys@microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3.14 039/114] scsi: add a blacklist flag which enables
 VPD page inquiries
Message-ID: <20140915212342.GB7014@sucs.org>
References: <20140915192641.428509513@linuxfoundation.org>
 <20140915192642.667743291@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915192642.667743291@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 12:25:39PM -0700, Greg Kroah-Hartman wrote:
> 3.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: "Martin K. Petersen" <martin.petersen@oracle.com>
> 
> commit c1d40a527e885a40bb9ea6c46a1b1145d42b66a0 upstream.
> 
> Despite supporting modern SCSI features some storage devices continue to
> claim conformance to an older version of the SPC spec. This is done for
> compatibility with legacy operating systems.
> 
> Linux by default will not attempt to read VPD pages on devices that
> claim SPC-2 or older. Introduce a blacklist flag that can be used to
> trigger VPD page inquiries on devices that are known to support them.
> 
> Reported-by: KY Srinivasan <kys@microsoft.com>
> Tested-by: KY Srinivasan <kys@microsoft.com>
> Reviewed-by: KY Srinivasan <kys@microsoft.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---

<snip>

> +#define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
>  #endif

Where is BLIST_TRY_VPD_PAGES being quirked on for Hyper-V's devices - is
there some later patch or some missing code I'm overlooking?

If the missing piece is f3cfabce7a2e92564d380de3aad4b43901fb7ae6, are
people sure it works? I'll retest but the last two times I tested it
(https://lkml.org/lkml/2014/7/23/615 and
https://lkml.org/lkml/2014/8/1/460 ) no one said anything after I said
thin provisioning wasn't enabled and James doesn't like quirking this on
every Hyper-V device (https://lkml.org/lkml/2014/7/24/393 )...

-- 
Sitsofe | http://sucs.org/~sits/
