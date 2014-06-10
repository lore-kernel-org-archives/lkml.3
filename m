Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaFJSak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:30:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46524 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaFJSaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:30:39 -0400
Date: Tue, 10 Jun 2014 20:27:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>
Subject: Re: [PATCH 1/1] drivers/edac/edac_module.c: remove unnecessary test
 on unsigned value
Message-ID: <20140610182719.GA28752@pd.tnic>
References: <1402341618-10674-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402341618-10674-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 09:20:18PM +0200, Fabian Frederick wrote:
> unsigned long value is never < 0
> 
> Cc: Doug Thompson <dougthompson@xmission.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/edac/edac_module.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/edac/edac_module.c b/drivers/edac/edac_module.c
> index a66941f..e6d1691 100644
> --- a/drivers/edac/edac_module.c
> +++ b/drivers/edac/edac_module.c
> @@ -28,7 +28,7 @@ static int edac_set_debug_level(const char *buf, struct kernel_param *kp)
>  	if (ret)
>  		return ret;
>  
> -	if (val < 0 || val > 4)
> +	if (val > 4)
>  		return -EINVAL;

Ok, so I don't know how you caught this but FWIW, we have those W= build
switches which trigger it too (which is a good thing that we have them
:-))

$ make W=1 drivers/edac/edac_module.o

...

drivers/edac/edac_module.c: In function ‘edac_set_debug_level’:
drivers/edac/edac_module.c:31:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
  if (val < 0 || val > 4)

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
