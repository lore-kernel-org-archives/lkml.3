Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab3FEVdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:33:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45916 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab3FEVdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:33:03 -0400
Date: Wed, 5 Jun 2013 23:32:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, bp@suse.de, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac: Add code to handle new MCE signatures for new
 models of Fam15h
Message-ID: <20130605213249.GD29856@pd.tnic>
References: <1370465403-2370-1-git-send-email-aravind.gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1370465403-2370-1-git-send-email-aravind.gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 03:50:03PM -0500, Aravind Gopalakrishnan wrote:
> There are some newer error signatures in Family 15h models 30h-3fh.
> Code has been added in the patch to support these new signatures.
> 
> Patch has been tested on Fam15h using mce_amd_inj facility and
> has been verified to work correctly.
> 
> Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
> ---
>  drivers/edac/mce_amd.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
> index f3f0c93..9de24c7 100644
> --- a/drivers/edac/mce_amd.c
> +++ b/drivers/edac/mce_amd.c
> @@ -134,7 +134,8 @@ static const char * const mc5_mce_desc[] = {
>  	"Physical register file AG0 port",
>  	"Physical register file AG1 port",
>  	"Flag register file",
> -	"DE error occurred"
> +	"DE error occurred",
> +	"Retire Status Queue Parity"

Since "parity error" is already in the printk below, I'm guessing this
string should be "Retire status queue" only?

No need to resend the patch, btw - I'll fix it up when applying.

>  };
>  
>  static bool f12h_mc0_mce(u16 ec, u8 xec)
> @@ -624,7 +625,7 @@ static void decode_mc5_mce(struct mce *m)
>  
>  	if (xec == 0x0 || xec == 0xc)
>  		pr_cont("%s.\n", mc5_mce_desc[xec]);
> -	else if (xec < 0xd)
> +	else if (xec <= 0xd)
>  		pr_cont("%s parity error.\n", mc5_mce_desc[xec]);
>  	else
>  		goto wrong_mc5_mce;

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
