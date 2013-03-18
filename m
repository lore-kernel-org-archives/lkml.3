Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3CRThP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:37:15 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:41823 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab3CRThM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:37:12 -0400
Date: Mon, 18 Mar 2013 12:38:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [ 052/100] drm/i915: Increase the RC6p threshold.
Message-ID: <20130318193828.GC13066@kroah.com>
References: <20130312223122.884099393@linuxfoundation.org>
 <20130312223128.581946761@linuxfoundation.org>
 <1363569069.3937.287.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363569069.3937.287.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 01:11:09AM +0000, Ben Hutchings wrote:
> On Tue, 2013-03-12 at 15:31 -0700, Greg Kroah-Hartman wrote:
> > 3.8-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Stéphane Marchesin <marcheu@chromium.org>
> > 
> > commit 0920a48719f1ceefc909387a64f97563848c7854 upstream.
> > 
> > This increases GEN6_RC6p_THRESHOLD from 100000 to 150000. For some
> > reason this avoids the gen6_gt_check_fifodbg.isra warnings and
> > associated GPU lockups, which makes my ivy bridge machine stable.
> > 
> > Signed-off-by: Stéphane Marchesin <marcheu@chromium.org>
> > Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  drivers/gpu/drm/i915/intel_pm.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/drivers/gpu/drm/i915/intel_pm.c
> > +++ b/drivers/gpu/drm/i915/intel_pm.c
> > @@ -2572,7 +2572,7 @@ static void gen6_enable_rps(struct drm_d
> >  	I915_WRITE(GEN6_RC_SLEEP, 0);
> >  	I915_WRITE(GEN6_RC1e_THRESHOLD, 1000);
> >  	I915_WRITE(GEN6_RC6_THRESHOLD, 50000);
> > -	I915_WRITE(GEN6_RC6p_THRESHOLD, 100000);
> > +	I915_WRITE(GEN6_RC6p_THRESHOLD, 150000);
> >  	I915_WRITE(GEN6_RC6pp_THRESHOLD, 64000); /* unused */
> >  
> >  	/* Check if we are enabling RC6 */
> 
> Is there any reason why this shouldn't be applied to 3.2.y and 3.4.y?
> The same function and writes are present, only in intel_display.c rather
> than intel_pm.c.

Ah, missed the fact that the file was renamed, nice catch.

I'll apply it to older kernels if the authors and maintainers say it's
safe to do so.

thanks,

greg k-h
