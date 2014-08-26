Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbaHZLAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:00:03 -0400
Received: from smtp.citrix.com ([66.165.176.89]:52432 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379AbaHZLAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:00:01 -0400
X-IronPort-AV: E=Sophos;i="5.04,403,1406592000"; 
   d="scan'208";a="165170070"
Message-ID: <53FC689D.7020507@citrix.com>
Date: Tue, 26 Aug 2014 11:59:41 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <stefan.bader@canonical.com>,
        <toshi.kani@hp.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <ville.syrjala@linux.intel.com>, <hpa@zytor.com>, <x86@kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] Support Xen pv-domains using PAT
References: <1409033783-12136-1-git-send-email-jgross@suse.com> <1409033783-12136-4-git-send-email-jgross@suse.com>
In-Reply-To: <1409033783-12136-4-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/14 07:16, Juergen Gross wrote:
> With the dynamical mapping between cache modes and pgprot values it is now
> possible to use all cache modes via the Xen hypervisor PAT settings in a
> pv domain.
> 
> All to be done is to read the PAT configuration MSR and set up the translation
> tables accordingly.
[...]
> +void xen_init_cache_types(void)
> +{
> +	pat_init_cache_modes();
> +}

No need to introduce xen_init_cache_types(), just call
pat_init_cache_modes() directly.

>  void xen_set_pat(u64 pat)
>  {
> -	/* We expect Linux to use a PAT setting of
> -	 * UC UC- WC WB (ignoring the PAT flag) */
> -	WARN_ON(pat != 0x0007010600070106ull);
> +	xen_init_cache_types();
>  }

Remove xen_set_pat() and remove the special-cased handling of the PAT
MSR from xen_write_msr_safe().

David
