Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3AUVc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:32:27 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:42370 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3AUVcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:32:23 -0500
Date: Tue, 22 Jan 2013 01:32:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Steven L. Kinney" <steven.kinney@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Myron Stowe <myron.stowe@redhat.com>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Kosina <jkosina@suse.cz>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/3] AMD IOMMUv2 PC resource management hooks
Message-ID: <20130121213218.GI25252@moon>
References: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
 <1358799658-6236-3-git-send-email-steven.kinney@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358799658-6236-3-git-send-email-steven.kinney@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 02:20:57PM -0600, Steven L. Kinney wrote:
> +u8 amd_iommu_v2_get_max_pc_banks(u16 devid)
> +{
> +	struct amd_iommu *iommu;
> +
> +	/* locate the iommu governing the devid */
> +	iommu = amd_iommu_rlookup_table[devid];
> +
> +	if (iommu)
> +		return iommu->max_banks;
> +
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL(amd_iommu_v2_get_max_pc_banks);

Hi Steven, may not it be better to return int here, instead of u8?
