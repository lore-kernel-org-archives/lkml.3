Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbaEMQNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:13:06 -0400
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:41822
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933006AbaEMQMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:12:43 -0400
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=TM7LSjVa c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=EBe6uRzgOt0A:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=zd2uoN0lAAAA:8
 a=aZvJa8UOWy6xEbSzRG0A:9 a=QEXdDO2ut3YA:10 a=_dQi-Dcv4p4A:10 a=wu_e27o_rKQA:10
Date: Tue, 13 May 2014 17:12:40 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Alex Deucher <alexdeucher@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: More breakage on HD7480D [ Aruba ]
Message-ID: <20140513161240.GA21635@milliways>
References: <20140512003405.GA3386@milliways>
 <20140512010310.GA4370@milliways>
 <53707926.5090609@amd.com>
 <20140512163207.GA23680@milliways>
 <53720091.5020302@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53720091.5020302@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 01:22:57PM +0200, Christian König wrote:
> Please try the attached patch it should fix your problem.
> 
> Thanks allot for this bug report, that was just a stupid typo in the
> original patch which would probably went unnoticed for years otherwise.
> 
> Christian.
> 

 Thanks, works like a charm.  If it adds any utility, feel free to
add

Tested-by: Ken Moffat <zarniwhoop@ntlworld.com>

ĸen

> Am 12.05.2014 18:32, schrieb Ken Moffat:
> >On Mon, May 12, 2014 at 09:32:54AM +0200, Christian König wrote:
> >>Hi Ken,
> >>
> >>*sigh* did I already mentioned that I hate PLLs? As soon as you fix
> >>something another use case immediately starts to break.
> >>
> >>Please provide dmesg output created with drm.debug=0xe with and without the
> >>patch breaking it.
> >>
> >>Thanks in advance,
> >>Christian.
> >>
> >  The reverted version is from linus's tree after -rc5 with the patch
> >reverted, I assume the version -00010-gc9a25d0fc393 will NOT match
> >any public tree because I used git revert in a local branch.  That
> >one works fine.
> >
> >  The bad version is from a random kernel which showed the problem
> >while I was bisecting, in this case rc2-00086.  I first tried
> >booting vanilla rc5, but for some reason my blind attempt to login
> >and run 'dmesg >dmesg.bad' failed.
> >
> >  Thanks.  Sorry you are having to deal with PLLs.
> >
> >ĸen
> 

> >From 8b5c70b48d73b533f0003639cdb68bcffe7c1293 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
> Date: Tue, 13 May 2014 12:50:54 +0200
> Subject: [PATCH] drm/radeon: fix typo in finding PLL params
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Otherwise the limit is raised to high.
> 
> Signed-off-by: Christian K??nig <christian.koenig@amd.com>
> ---
>  drivers/gpu/drm/radeon/radeon_display.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
> index 408b6ac..f00dbbf 100644
> --- a/drivers/gpu/drm/radeon/radeon_display.c
> +++ b/drivers/gpu/drm/radeon/radeon_display.c
> @@ -999,7 +999,7 @@ void radeon_compute_pll_avivo(struct radeon_pll *pll,
>  
>  	/* avoid high jitter with small fractional dividers */
>  	if (pll->flags & RADEON_PLL_USE_FRAC_FB_DIV && (fb_div % 10)) {
> -		fb_div_min = max(fb_div_min, (9 - (fb_div % 10)) * 20 + 60);
> +		fb_div_min = max(fb_div_min, (9 - (fb_div % 10)) * 20 + 50);
>  		if (fb_div < fb_div_min) {
>  			unsigned tmp = DIV_ROUND_UP(fb_div_min, fb_div);
>  			fb_div *= tmp;
> -- 
> 1.9.1
> 


-- 
das eine Mal als Tragödie, dieses Mal als Farce
