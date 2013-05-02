Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3EBKNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:13:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36969 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab3EBKM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:12:58 -0400
Date: Thu, 2 May 2013 12:13:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm: don't check modeset locks in panic handler
Message-ID: <20130502101308.GA16684@pd.tnic>
References: <CAPM=9tw-Ssu7ZYBZX7ipGt9w7zYG91tKbWZguM5DLPaqTakJPA@mail.gmail.com>
 <1367480585-22814-1-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1367480585-22814-1-git-send-email-daniel.vetter@ffwll.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 09:43:05AM +0200, Daniel Vetter wrote:
> Since we know that locking is broken in that case and it's more
> important to not flood the dmesg with random gunk.
> 
> Cc: Dave Airlie <airlied@gmail.com>
> Cc: Borislav Petkov <bp@alien8.de>
> References: https://groups.google.com/forum/?fromgroups=#!topic/linux.kernel/QFzFxSUeV4I

Yeah, we have this nice redirector service on k.org which uses the
Message-ID only and doesn't rely on some external URLs remaining stable.
You could use that instead:

Link: http://lkml.kernel.org/r/20130502000206.GH15623@pd.tnic

> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  drivers/gpu/drm/drm_crtc.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index 792c3e3..3be0802 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -78,6 +78,10 @@ void drm_warn_on_modeset_not_all_locked(struct drm_device *dev)
>  {
>  	struct drm_crtc *crtc;
>  
> +	/* Locking is currently fubar in the panic handler. */
> +	if (oops_in_progress)
> +		return;
> +
>  	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head)
>  		WARN_ON(!mutex_is_locked(&crtc->mutex));

Yep, thanks.

Reported-and-tested-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
