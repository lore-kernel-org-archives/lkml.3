Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073Ab3ICOSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:18:30 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:56466 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab3ICOS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:18:28 -0400
Date: Tue, 3 Sep 2013 10:18:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130903141824.GD10522@htj.dyndns.org>
References: <cover.1378111919.git.agordeev@redhat.com>
 <3bb1b4375655ecfde5017cc70973d078f2434d5d.1378111919.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bb1b4375655ecfde5017cc70973d078f2434d5d.1378111919.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 11:00:28AM +0200, Alexander Gordeev wrote:
> +	if (hpriv->flags & AHCI_HFLAG_NO_MSI)
> +		goto intx;
> +
> +	rc = pci_enable_msi_block_part(pdev, n_ports, AHCI_MAX_PORTS);
> +	if (!rc)
> +		return AHCI_MAX_PORTS;
> +	if (rc < 0)
> +		goto intx;
> +
> +	maxvec = rc;
> +	rc = pci_enable_msi_block_part(pdev, n_ports, maxvec);
> +	if (!rc)
> +		return maxvec;
> +	if (rc < 0)
> +		goto intx;

Why is the above fallback necessary?  The only other number which
makes sense is roundup_pow_of_two(n_ports), right?  What does the
above fallback logic buy us?

Thanks.

-- 
tejun
