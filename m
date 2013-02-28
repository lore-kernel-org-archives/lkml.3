Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3B1LSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:18:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:41237 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab3B1LSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 06:18:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,755,1355126400"; 
   d="scan'208";a="297133738"
Date: Thu, 28 Feb 2013 11:18:19 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [git pull] drm merge for 3.9-rc1
Message-ID: <20130228111819.GF11892@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Dave Airlie <airlied@gmail.com>,
	DRI <dri-devel@lists.freedesktop.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>
References: <CA+icZUXG7WgRap2-oQGBr_s=QbE0QW6_zChDRqC-eEzrWR3Y5g@mail.gmail.com>
 <CA+icZUUP0hLjkTjsAGbhoT1QG55X2062G5KCCDsKkhDyM_SQEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUUP0hLjkTjsAGbhoT1QG55X2062G5KCCDsKkhDyM_SQEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 12:06:28AM +0100, Sedat Dilek wrote:
> On Wed, Feb 27, 2013 at 11:36 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > Hi,
> >
> > I am seeing this also on Linux-Next.
> >
> > /var/log/kern.log:Feb 27 22:52:35 fambox kernel: [   28.202381]
> > [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
> > (has irq: 1)!
> > /var/log/kern.log:Feb 27 22:52:35 fambox kernel: [   28.210588]
> > [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
> > (has irq: 1)!
> >
> > /var/log/kern.log.1:Feb 22 07:36:04 fambox kernel: [   27.408280]
> > [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
> > (has irq: 1)!
> >
> > This seems to be hard reproducible...
> > Laptop-LCD... Sandybridge Mobile-GT2.
> >
> > Is there a way to force the error?
> >
> > Possible patch see [1].
> >
> > - Sedat -
> >
> > [1] https://patchwork.kernel.org/patch/2192721/

That was:

+	if (!done) {
+		status = I915_READ_NOTRACE(ch_ctl);
+		DRM_ERROR("dp aux hw did not signal timeout (has irq:
%i), status=%08x!\n",
+			  has_aux_irq, status);
+	}

You applied

+	if (!done) {
+		status = I915_READ_NOTRACE(ch_ctl);
+		DRM_ERROR("dp aux hw did not signal timeout (has irq:
%i), status=%08x!\n",
+			  has_aux_irq, status);
+	{

That second '{' is the source of the compile error.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
