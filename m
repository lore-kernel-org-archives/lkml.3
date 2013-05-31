Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3EaPXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:23:42 -0400
Received: from mo5.mail-out.ovh.net ([178.32.228.5]:35404 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3EaPXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:23:35 -0400
Date: Fri, 31 May 2013 17:19:26 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 2/2] atmel_lcdfb: blank the backlight on remove
Message-ID: <20130531151926.GR19468@game.jcrosoft.org>
References: <1370010519-18691-1-git-send-email-richard.genoud@gmail.com>
 <1370010519-18691-2-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370010519-18691-2-git-send-email-richard.genoud@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13876716353891249061
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:28 Fri 31 May     , Richard Genoud wrote:
> When removing atmel_lcdfb module, the backlight is unregistered but not
> blanked. (only for CONFIG_BACKLIGHT_ATMEL_LCDC case).
> This can result in the screen going full white depending on how the PWM
> is wired.
> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>  drivers/video/atmel_lcdfb.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
> index 6e6491f..e00318f 100644
> --- a/drivers/video/atmel_lcdfb.c
> +++ b/drivers/video/atmel_lcdfb.c
> @@ -223,8 +223,13 @@ static void init_backlight(struct atmel_lcdfb_info *sinfo)
>  
>  static void exit_backlight(struct atmel_lcdfb_info *sinfo)
>  {
> -	if (sinfo->backlight)
> +	if (sinfo->backlight) {
if (!sinfo->backlight)
	return;

	other look ok 

if you want ot hte next RC you have 3h to send a v2 before I work off for few
days

Best Regards,
J.
