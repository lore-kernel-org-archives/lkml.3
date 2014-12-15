Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaLOLR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:17:29 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:49683 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLOLRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:17:23 -0500
Date: Mon, 15 Dec 2014 11:17:16 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 03/18] arm64/uaccess: fix sparse errors
Message-ID: <20141215111716.GG20738@arm.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
 <1418575877-21488-4-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418575877-21488-4-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 04:52:09PM +0000, Michael S. Tsirkin wrote:
> virtio wants to read bitwise types from userspace using get_user.  At the
> moment this triggers sparse errors, since the value is passed through an
> integer.
> 
> Fix that up using __force.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/arm64/include/asm/uaccess.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> index 3bf8f4e..8d66bcf 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> @@ -147,7 +147,7 @@ do {									\
>  	default:							\
>  		BUILD_BUG();						\
>  	}								\
> -	(x) = (__typeof__(*(ptr)))__gu_val;				\
> +	(x) = (__force __typeof__(*(ptr)))__gu_val;				\
>  } while (0)
>  
>  #define __get_user(x, ptr)						\

Acked-by: Will Deacon <will.deacon@arm.com>

Will
