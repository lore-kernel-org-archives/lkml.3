Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161615Ab3DKM3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:29:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45469 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934150Ab3DKM3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:29:49 -0400
Date: Thu, 11 Apr 2013 14:29:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@sr71.net>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/5] break up slow_virt_to_phys()
Message-ID: <20130411122944.GA27062@pd.tnic>
References: <20130410233249.7FFCB63B@viggo.jf.intel.com>
 <20130410233254.EF273179@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130410233254.EF273179@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 04:32:54PM -0700, Dave Hansen wrote:
> +phys_addr_t slow_virt_to_phys(void *virt_addr)
> +{
> +	phys_addr_t result;
> +	int ret;
> +
> +	ret = kernel_lookup_vaddr(virt_addr, &result);
> +	BUG_ON(ret);

Isn't that BUG_ON still too harsh though? How about WARN_ON instead?
It would still create a lot of noise so that it gets fixed without
bringing down the system.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
