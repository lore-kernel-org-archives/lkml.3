Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaJ1Rix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:38:53 -0400
Received: from smtp.citrix.com ([66.165.176.89]:44942 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaJ1Riw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:38:52 -0400
X-IronPort-AV: E=Sophos;i="5.04,804,1406592000"; 
   d="scan'208";a="185697826"
Message-ID: <544FD3A2.1050903@citrix.com>
Date: Tue, 28 Oct 2014 17:34:26 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] Xen: Delay remapping memory of pv-domain
References: <1414421551-31555-1-git-send-email-jgross@suse.com> <1414421551-31555-2-git-send-email-jgross@suse.com>
In-Reply-To: <1414421551-31555-2-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can these patches be split up?  They're hard to review as-is.  e.g., the
changes to page allocation look they could be split out.

On 27/10/14 14:52, Juergen Gross wrote:
> Early in the boot process the memory layout of a pv-domain is changed
> to match the E820 map (either the host one for Dom0 or the Xen one)
> regarding placement of RAM and PCI holes. This requires removing memory
> pages initially located at positions not suitable for RAM and adding
> them later at higher addresses where no restrictions apply.

How does this impact Matt Rushton's recent change to ensure the
relocated frames are contiguous?

The change was "xen/setup: Remap Xen Identity Mapped RAM" (4fbb67e3c87).

> +	/* Update kernel mapping */
> +	if (HYPERVISOR_update_va_mapping((unsigned long)__va(pfn << PAGE_SHIFT),
> +					 mfn_pte(mfn, PAGE_KERNEL), 0)) {
> +		WARN(1, "Failed to update kernel mapping for mfn=%ld pfn=%ld\n",
> +		      mfn, pfn);
> +		return 0;

I think you need to check if this is a PFN for a high page before
updating the mapping.

David
