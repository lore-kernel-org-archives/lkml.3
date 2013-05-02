Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935Ab3EBUmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:42:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38987 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3EBUmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:42:08 -0400
Date: Thu, 2 May 2013 22:45:11 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Borislav Petkov <bp@alien8.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm: don't check modeset locks in panic handler
Message-ID: <20130502204511.GH5763@phenom.ffwll.local>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@gmail.com>, stable@vger.kernel.org
References: <CAPM=9tw-Ssu7ZYBZX7ipGt9w7zYG91tKbWZguM5DLPaqTakJPA@mail.gmail.com>
 <1367480585-22814-1-git-send-email-daniel.vetter@ffwll.ch>
 <20130502101308.GA16684@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502101308.GA16684@pd.tnic>
X-Operating-System: Linux phenom 3.9.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 12:13:08PM +0200, Borislav Petkov wrote:
> On Thu, May 02, 2013 at 09:43:05AM +0200, Daniel Vetter wrote:
> > Since we know that locking is broken in that case and it's more
> > important to not flood the dmesg with random gunk.
> > 
> > Cc: Dave Airlie <airlied@gmail.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > References: https://groups.google.com/forum/?fromgroups=#!topic/linux.kernel/QFzFxSUeV4I
> 
> Yeah, we have this nice redirector service on k.org which uses the
> Message-ID only and doesn't rely on some external URLs remaining stable.
> You could use that instead:
> 
> Link: http://lkml.kernel.org/r/20130502000206.GH15623@pd.tnic
> 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > ---
> >  drivers/gpu/drm/drm_crtc.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> > index 792c3e3..3be0802 100644
> > --- a/drivers/gpu/drm/drm_crtc.c
> > +++ b/drivers/gpu/drm/drm_crtc.c
> > @@ -78,6 +78,10 @@ void drm_warn_on_modeset_not_all_locked(struct drm_device *dev)
> >  {
> >  	struct drm_crtc *crtc;
> >  
> > +	/* Locking is currently fubar in the panic handler. */
> > +	if (oops_in_progress)
> > +		return;
> > +
> >  	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head)
> >  		WARN_ON(!mutex_is_locked(&crtc->mutex));
> 
> Yep, thanks.
> 
> Reported-and-tested-by: Borislav Petkov <bp@suse.de>

Thanks for testing, patch applied to drm-intel-fixes.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
