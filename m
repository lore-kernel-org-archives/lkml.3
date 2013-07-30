Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3G3A2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:28:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab3G3A2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:28:06 -0400
Date: Mon, 29 Jul 2013 20:27:55 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: daniel.vetter@ffwll.ch, airlied@redhat.com
Subject: Re: drm/crtc-helper: explicit DPMS on after modeset
Message-ID: <20130730002755.GB3853@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	daniel.vetter@ffwll.ch, airlied@redhat.com
References: <20130723230814.8DE656601B0@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723230814.8DE656601B0@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 11:08:14PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=25f397a429dfa43f22c278d0119a60a343aa568f
 > Commit:     25f397a429dfa43f22c278d0119a60a343aa568f
 > Author:     Daniel Vetter <daniel.vetter@ffwll.ch>
 > AuthorDate: Fri Jul 19 18:57:11 2013 +0200
 > Committer:  Dave Airlie <airlied@redhat.com>
 > CommitDate: Mon Jul 22 09:55:17 2013 +1000
 > 
 >     drm/crtc-helper: explicit DPMS on after modeset

 > --- a/drivers/gpu/drm/drm_crtc_helper.c
 > +++ b/drivers/gpu/drm/drm_crtc_helper.c
 > @@ -677,6 +677,11 @@ int drm_crtc_helper_set_config(struct drm_mode_set *set)
 >  					/* don't break so fail path works correct */
 >  					fail = 1;
 >  				break;
 > +
 > +				if (connector->dpms != DRM_MODE_DPMS_ON) {
 > +					DRM_DEBUG_KMS("connector dpms not on, full mode switch\n");
 > +					mode_changed = true;
 > +				}
 >  			}

This code will never get executed. (See the break above it).

	Dave

