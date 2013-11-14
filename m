Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3KNP3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:29:55 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54963 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753748Ab3KNP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:29:48 -0500
Date: Thu, 14 Nov 2013 15:29:07 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 4/4] arm64: advertise CPU features for modalias matching
Message-ID: <20131114152907.GL20261@arm.com>
References: <1384165175-16134-1-git-send-email-ard.biesheuvel@linaro.org>
 <1384165175-16134-5-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384165175-16134-5-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 10:19:35AM +0000, Ard Biesheuvel wrote:
> +ssize_t arch_print_cpu_modalias(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	unsigned int caps;
> +	ssize_t n;
> +	int i;
> +
> +	/*
> +	 * With 32 features maximum (taking 5 bytes each to print), we don't
> +	 * need to worry about overrunning the PAGE_SIZE sized buffer.
> +	 */
> +	n = sprintf(buf, "cpu:type:arm64:feature:");

I would use "aarch64" here instead of arm64 for consistency with the
architecture mode, compiler triplet and ELF_PLATFORM definition in the
kernel.

-- 
Catalin
