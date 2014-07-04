Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893AbaGDKoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:44:34 -0400
Received: from 8bytes.org ([85.214.48.195]:42328 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbaGDKod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:44:33 -0400
Date: Fri, 4 Jul 2014 12:44:30 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, alex.williamson@redhat.com
Subject: Re: [PATCH 1/3] iommu/fsl: Fix PAMU window size check.
Message-ID: <20140704104430.GD13434@8bytes.org>
References: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
 <1403618237-26248-2-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403618237-26248-2-git-send-email-Varun.Sethi@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jul  4 12:44:32 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53b6859020861579610763
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 07:27:15PM +0530, Varun Sethi wrote:
>  	/* window size is 2^(WSE+1) bytes */
> -	return __ffs(addrspace_size) - 1;
> +	return fls64(addrspace_size) - 2;

This looks bogus, why do you replace ffs (find-first-bit) by fls
(find-last-bit)?


	Joerg


