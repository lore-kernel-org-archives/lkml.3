Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaIXQxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:53:31 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:55254 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbaIXQx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:53:28 -0400
Date: Wed, 24 Sep 2014 10:53:20 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/12] tpm: TPM2 support for tpm_pcr_read()
Message-ID: <20140924165320.GD8898@obsidianresearch.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1411549562-24242-4-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411549562-24242-4-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:05:53PM +0300, Jarkko Sakkinen wrote:

> +static struct tpm_input_header tpm2_pcrread_header = {

Missing const - all of these static structures in tpm2-cmds.c are missing the
const, please fix them all.

> +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> +	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
> +	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
> +};

BTW, I always thought this was a goofy and very expensive way to store
3 values and zero initialize. If you want to do something different in
the tpm2-cmds.c that would be great too...

Jason
