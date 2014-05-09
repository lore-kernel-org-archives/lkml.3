Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbaEILPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:15:20 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:41575 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbaEILPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:15:18 -0400
Date: Fri, 9 May 2014 12:15:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        peter.chen@freescale.com
Subject: Re: [PATCH] mfd: syscon: Include linux/err.h to fix build error
Message-ID: <20140509111513.GT5767@lee--X1>
References: <1399633660-17897-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399633660-17897-1-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 May 2014, Tushar Behera wrote:

> commit df73de9b0d412 ("mfd: syscon: Return -ENOSYS if CONFIG_MFD_SYSCON
> is not enabled") introduced fallbacks for APIs, but missed out on adding
> the header file. This would work only if linux/err.h is also included
> in the source code from where this file is included. It would be better
> to include linux/err.h in file to remove possible build errors.
> 
> Without this patch, we get following and similar build errors if this
> header file is included in some source file and CONFIG_MFD_SYSCON is
> not enabled.
> 
> include/linux/mfd/syscon.h: In function ‘syscon_node_to_regmap’:
> include/linux/mfd/syscon.h:30:2: error: implicit declaration of function ‘ERR_PTR’ [-Werror=implicit-function-declaration]
>   return ERR_PTR(-ENOSYS);
>   ^
> include/linux/mfd/syscon.h:30:18: error: ‘ENOSYS’ undeclared (first use in this function)
>   return ERR_PTR(-ENOSYS);
>                   ^
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  include/linux/mfd/syscon.h |    2 ++
>  1 file changed, 2 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
