Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaE0M7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:59:23 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42749 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaE0M7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:59:21 -0400
Date: Tue, 27 May 2014 14:56:22 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrzej Hajda <a.hajda@samsung.com>, Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH linux-next] imx-drm: imx-tve: remove unused variable
Message-ID: <20140527125622.GA14841@phenom.ffwll.local>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-next@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
	Dave Airlie <airlied@linux.ie>
References: <1401054854-20932-1-git-send-email-vincent.stehle@laposte.net>
 <20140525221235.GA26619@kroah.com>
 <20140526091252.2a4496d4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140526091252.2a4496d4@canb.auug.org.au>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 09:12:52AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> On Sun, 25 May 2014 15:12:35 -0700 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > On Sun, May 25, 2014 at 11:54:14PM +0200, Vincent Stehlé wrote:
> > > Commit f9b0e251dfbf 'drm: make mode_valid callback optional' left variable ret
> > > unused; remove it.
> > > 
> > > This fixes the following compilation warning:
> > > 
> > >   drivers/staging/imx-drm/imx-tve.c: In function ‘imx_tve_connector_mode_valid’:
> > >   drivers/staging/imx-drm/imx-tve.c:252:6: warning: unused variable ‘ret’ [-Wunused-variable]
> > 
> > It doesn't apply to my tree :(
> 
> Yeah, commit f9b0e251dfbf 'drm: make mode_valid callback optional' is
> in the drm tree, so this patch needs to go to Dave Airlie (cc'd).
> Though Daniel Vetter may want to send it on.
> 
> For Dave's benefit, here is the patch again:

I've pulled it into my drm-stuff branch so it doesn't get lost. Should
land in 3.16 one way or the other.

Thanks, Daniel

> 
> From:	Vincent Stehlé <vincent.stehle@laposte.net>
> Subject: [PATCH linux-next] imx-drm: imx-tve: remove unused variable
> Date:	Sun, 25 May 2014 23:54:14 +0200
> 
> Commit f9b0e251dfbf 'drm: make mode_valid callback optional' left variable ret
> unused; remove it.
> 
> This fixes the following compilation warning:
> 
>   drivers/staging/imx-drm/imx-tve.c: In function ‘imx_tve_connector_mode_valid’:
>   drivers/staging/imx-drm/imx-tve.c:252:6: warning: unused variable ‘ret’ [-Wunused-variable]
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> Hi,
> 
> This can be seen with e.g. linux next-20140523 and arm allmodconfig.
> 
> Best regards,
> 
> V.
> 
>  drivers/staging/imx-drm/imx-tve.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
> index 3e8b0a1..4caef2b1 100644
> --- a/drivers/staging/imx-drm/imx-tve.c
> +++ b/drivers/staging/imx-drm/imx-tve.c
> @@ -249,7 +249,6 @@ static int imx_tve_connector_mode_valid(struct drm_connector *connector,
>  {
>  	struct imx_tve *tve = con_to_tve(connector);
>  	unsigned long rate;
> -	int ret;
>  
>  	/* pixel clock with 2x oversampling */
>  	rate = clk_round_rate(tve->clk, 2000UL * mode->clock) / 2000;
> -- 
> 2.0.0.rc2
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
