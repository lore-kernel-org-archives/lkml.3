Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180AbaIFCfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 22:35:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53369 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaIFCfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 22:35:39 -0400
Date: Fri, 5 Sep 2014 19:35:37 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] toshiba_acpi: Fix illumination not available on
 certain models
Message-ID: <20140906023537.GA11389@vmdeb7>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
 <1409937247-2525-3-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409937247-2525-3-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 11:14:04AM -0600, Azael Avalos wrote:
> Some Toshiba models with illumination support set a different
> value on the returned codes, thus not allowing the illumination
> LED to be registered, where it should be.
> 
> This patch removes a check from toshiba_illumination_available
> function to allow such models to register the illumination LED.
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> ---
>  drivers/platform/x86/toshiba_acpi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index a149bc6..4803e7b 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -436,7 +436,7 @@ static int toshiba_illumination_available(struct toshiba_acpi_dev *dev)
>  	if (ACPI_FAILURE(status) || out[0] == HCI_FAILURE) {
>  		pr_err("ACPI call to query Illumination support failed\n");
>  		return 0;
> -	} else if (out[0] == HCI_NOT_SUPPORTED || out[1] != 1) {
> +	} else if (out[0] == HCI_NOT_SUPPORTED) {

OK, but by eliminating the check, supposedly certain models which do not support
illumination but do not report it via out[0], but instead via out[1], will now
attempt to use illumination - correct?

The end result being user calls to an ACPI function which at best doesn't exist
and at worst.... does, but does something entirely different.

I admit the potential for a problem is slight, but is it possible to check
something explicit for support on the newer models rather than removing an
existing check?

-- 
Darren Hart
Intel Open Source Technology Center
