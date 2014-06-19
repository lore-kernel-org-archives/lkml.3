Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaFSMub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:50:31 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:27592 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754019AbaFSMua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:50:30 -0400
Date: Thu, 19 Jun 2014 13:50:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 13/24] Drivers:input: Use is_compat_task for ARM64 also.
Message-ID: <20140619125025.GB8476@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
 <1400914939-9708-14-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400914939-9708-14-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 12:02:08AM -0700, Andrew Pinski wrote:
> diff --git a/drivers/input/input-compat.h b/drivers/input/input-compat.h
> index 148f66f..6656957 100644
> --- a/drivers/input/input-compat.h
> +++ b/drivers/input/input-compat.h
> @@ -19,7 +19,7 @@
>  
>  /* Note to the author of this code: did it ever occur to
>     you why the ifdefs are needed? Think about it again. -AK */
> -#if defined(CONFIG_X86_64) || defined(CONFIG_TILE)
> +#if defined(CONFIG_X86_64) || defined(CONFIG_TILE) || defined(CONFIG_ARM64)
>  #  define INPUT_COMPAT_TEST is_compat_task()
>  #elif defined(CONFIG_S390)
>  #  define INPUT_COMPAT_TEST test_thread_flag(TIF_31BIT)

And this patch could be removed if we keep TIF_32BIT common.

-- 
Catalin
