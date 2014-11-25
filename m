Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaKYLp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:45:59 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33677 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaKYLp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:45:56 -0500
Date: Tue, 25 Nov 2014 11:45:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lin Yongting <linyongting@gmail.com>
Cc: victor.kamensky@linaro.org, nico@linaro.org,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, linyongting@huawei.com
Subject: Re: [PATCH] ARM: Add unwinding support for memmove function
Message-ID: <20141125114541.GE3836@n2100.arm.linux.org.uk>
References: <1416836757-30547-1-git-send-email-linyongting@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416836757-30547-1-git-send-email-linyongting@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 09:45:56PM +0800, Lin Yongting wrote:
> @@ -27,12 +28,17 @@
>   */
>  
>  ENTRY(memmove)
> +	UNWIND(	.fnstart			)
>  
>  		subs	ip, r0, r1
>  		cmphi	r2, ip
>  		bls	memcpy
>  
>  		stmfd	sp!, {r0, r4, lr}
> +	UNWIND(	.fnend				)
> +
> +	UNWIND(	.fnstart			)
> +	UNWIND(	.save	{r0, r4, lr}		) @ in first stmfd block

This is pretty horrid, but I guess it's necessary due to how the unwinder
works.  If no one has any objections, please drop it in the patch system
and I'll queue it for the next merge window.

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
