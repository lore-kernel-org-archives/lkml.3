Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3IUQDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 12:03:16 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46276 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3IUQDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 12:03:15 -0400
Date: Sat, 21 Sep 2013 19:03:06 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Meelis Roos <mroos@linux.ee>, intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: i915 pipe A assertion failure (expected on, current off)
Message-ID: <20130921160306.GE3501@sci.fi>
Mail-Followup-To: Daniel Vetter <daniel.vetter@ffwll.ch>,
	Meelis Roos <mroos@linux.ee>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>
References: <alpine.SOC.1.00.1308261610280.25531@math.ut.ee>
 <alpine.SOC.1.00.1309211825490.9193@math.ut.ee>
 <CAKMK7uHynzChMurTLAYMfeRF07aDJxes-6eSO1iDbrET8xD84Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uHynzChMurTLAYMfeRF07aDJxes-6eSO1iDbrET8xD84Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 05:48:42PM +0200, Daniel Vetter wrote:
> On Sat, Sep 21, 2013 at 5:29 PM, Meelis Roos <mroos@linux.ee> wrote:
> >> Tried 3.11-rc7 on Thinkpad X30 (first 3-11-rc tried on this hw). Works
> >> but i915 gives strange assertion failure with WARNING stack trace. This
> >> is new since 3.10.
> >
> > It is still there with 3.12-rc1 but now I git around to bisecting it.
> > This is the commit that introduces the warning.
> >
> > commit 9f11a9e4e50006b615ba94722dfc33ced89664cf
> > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Date:   Thu Jun 13 00:54:58 2013 +0200
> >
> >     drm/i915: set up PIPECONF explicitly for i9xx/vlv platforms
> 
> My apologies for not responding to your first report, fell through the
> cracks somehow. Can you please boot with drm.debug=0xe, reproduce the
> WARN and grab the full dmesg (please make sure everything from boot-up
> is in there). That's usually enough to figure out what's going wrong
> here.

I'd say it's a simple matter of forgetting about QUIRK_PIPEA_FORCE in
i9xx_set_pipeconf().

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
