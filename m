Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbaAHU6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:58:15 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59558 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750839AbaAHU6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:58:13 -0500
Date: Wed, 8 Jan 2014 20:57:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: x86@kernel.org, linuxppc-dev@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH RFC 2/3] ARM: kernel: add support for cpu cache
	information
Message-ID: <20140108205754.GN27432@n2100.arm.linux.org.uk>
References: <1389209168-17189-1-git-send-email-sudeep.holla@arm.com> <1389209168-17189-3-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389209168-17189-3-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 07:26:07PM +0000, Sudeep Holla wrote:
> +#if __LINUX_ARM_ARCH__ < 7 /* pre ARMv7 */
> +
> +#define MAX_CACHE_LEVEL		1	/* Only 1 level supported */
> +#define CTR_CTYPE_SHIFT		24
> +#define CTR_CTYPE_MASK		(1 << CTR_CTYPE_SHIFT)
> +
> +static inline unsigned int get_ctr(void)
> +{
> +	unsigned int ctr;
> +	asm volatile ("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
> +	return ctr;
> +}
> +
> +static enum cache_type get_cache_type(int level)
> +{
> +	if (level > MAX_CACHE_LEVEL)
> +		return CACHE_TYPE_NOCACHE;
> +	return get_ctr() & CTR_CTYPE_MASK ?
> +		CACHE_TYPE_SEPARATE : CACHE_TYPE_UNIFIED;

So, what do we do for CPUs that don't implement the CTR?  Just return
random rubbish based on decoding the CPU Identity register as if it
were the cache type register?

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
