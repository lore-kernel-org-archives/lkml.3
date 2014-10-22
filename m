Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaJVQMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:12:19 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40996 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755930AbaJVQMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:12:15 -0400
Date: Wed, 22 Oct 2014 17:11:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: mathieu.poirier@linaro.org
Cc: catalin.marinas@arm.com, stefano.stabellini@eu.citrix.com,
        ezequiel.garcia@free-electrons.com, Liviu.Dudau@arm.com,
        thomas.petazzoni@free-electrons.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: supplementing IO accessors with 64 bit capability
Message-ID: <20141022161155.GB27405@n2100.arm.linux.org.uk>
References: <1413993983-17310-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413993983-17310-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:06:23AM -0600, mathieu.poirier@linaro.org wrote:
> @@ -306,10 +324,13 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
>  					__raw_readw(c)); __r; })
>  #define readl_relaxed(c) ({ u32 __r = le32_to_cpu((__force __le32) \
>  					__raw_readl(c)); __r; })
> +#define readq_relaxed(c) ({ u64 __r = le64_to_cpu((__force __le64) \
> +					__raw_readq(c)); __r; })
>  
>  #define writeb_relaxed(v,c)	__raw_writeb(v,c)
>  #define writew_relaxed(v,c)	__raw_writew((__force u16) cpu_to_le16(v),c)
>  #define writel_relaxed(v,c)	__raw_writel((__force u32) cpu_to_le32(v),c)
> +#define writeq_relaxed(v,c)	__raw_writeq((__force u64) cpu_to_le64(v),c)

You should only define these if we have the corresponding __raw_ versions
too.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
