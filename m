Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaIDV6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:58:30 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40041 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbaIDV61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:58:27 -0400
Date: Thu, 4 Sep 2014 15:58:21 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI/AER: Make linux/aer.h standalone includable
Message-ID: <20140904215821.GF17125@google.com>
References: <1407240535-19564-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407240535-19564-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 02:08:55PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The header file references u16, u32 and struct pci_dev types, but they
> are not defined in the header nor does the header pull in the necessary
> includes for them. This causes build breakage when the file is included
> without any of the dependencies being satisfied from somewhere else.
> 
> Fix this by including linux/types.h (for u16 and u32) and by adding a
> forward-declaration of struct pci_dev.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Applied to pci/misc for v3.18, thanks!  I dropped the struct pci_dev
declaration because it was already added by 5ccb8225abf2 ("x86/ras: Fix
build warnings in <linux/aer.h>")

> ---
>  include/linux/aer.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/aer.h b/include/linux/aer.h
> index 4dbaa7081530..04bcf33a3e3a 100644
> --- a/include/linux/aer.h
> +++ b/include/linux/aer.h
> @@ -7,6 +7,10 @@
>  #ifndef _AER_H_
>  #define _AER_H_
>  
> +#include <linux/types.h>
> +
> +struct pci_dev;
> +
>  #define AER_NONFATAL			0
>  #define AER_FATAL			1
>  #define AER_CORRECTABLE			2
> -- 
> 2.0.4
> 
