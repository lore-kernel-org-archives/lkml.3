Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaFHR6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 13:58:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48204 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaFHR6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 13:58:40 -0400
Date: Sun, 8 Jun 2014 20:58:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Choi Gi-yong <yong@gnoy.org>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: speakup: ERROR: Fix macro parenthesis.
Message-ID: <20140608175823.GC5500@mwanda>
References: <1402236777-10914-1-git-send-email-yong@gnoy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402236777-10914-1-git-send-email-yong@gnoy.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like this patch is adding blank lines not parenthesis like the
subject says.

regards,
dan carpenter

On Sun, Jun 08, 2014 at 11:12:57PM +0900, Choi Gi-yong wrote:
> Signed-off-by: Choi Gi-yong <yong@gnoy.org>
> ---
>  drivers/staging/speakup/speakup_acntpc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/speakup/speakup_acntpc.c b/drivers/staging/speakup/speakup_acntpc.c
> index 31f952b..f70b698 100644
> --- a/drivers/staging/speakup/speakup_acntpc.c
> +++ b/drivers/staging/speakup/speakup_acntpc.c
> @@ -35,7 +35,7 @@
>  #include "speakup_acnt.h" /* local header file for Accent values */
>  
>  #define DRV_VERSION "2.10"
> -#define PROCSPEECH '\r'
> +#define PROCSPEECH ('\r')
>  
>  static int synth_probe(struct spk_synth *synth);
>  static void accent_release(void);
> @@ -152,8 +152,10 @@ static inline bool synth_full(void)
>  static const char *synth_immediate(struct spk_synth *synth, const char *buf)
>  {
>  	u_char ch;
> +
>  	while ((ch = *buf)) {
>  		int timeout = SPK_XMITR_TIMEOUT;
> +
>  		if (ch == '\n')
>  			ch = PROCSPEECH;
>  		if (synth_full())
> @@ -257,6 +259,7 @@ static int synth_probe(struct spk_synth *synth)
>  {
>  	unsigned int port_val = 0;
>  	int i = 0;
> +
>  	pr_info("Probing for %s.\n", synth->long_name);
>  	if (port_forced) {
>  		speakup_info.port_tts = port_forced;
> -- 
> 1.9.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
