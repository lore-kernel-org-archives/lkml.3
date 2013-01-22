Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3AVWhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:37:19 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38216 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3AVWhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:37:06 -0500
Date: Tue, 22 Jan 2013 23:39:08 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Sankaran, Rajesh" <rajesh.sankaran@intel.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Adam Jackson <ajax@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] iommu/intel: disable DMAR for g4x integrated gfx
Message-ID: <20130122223908.GN31870@phenom.ffwll.local>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	"Sankaran, Rajesh" <rajesh.sankaran@intel.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>, Adam Jackson <ajax@redhat.com>,
	stable@vger.kernel.org
References: <1358722213-2075-1-git-send-email-daniel.vetter@ffwll.ch>
 <1358795028.5523.6.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358795028.5523.6.camel@shinybook.infradead.org>
X-Operating-System: Linux phenom 3.8.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 01:03:48PM -0600, David Woodhouse wrote:
> On Sun, 2013-01-20 at 23:50 +0100, Daniel Vetter wrote:
> > DMAR support on g4x/gm45 integrated gpus seems to be totally busted.
> > So don't bother, but instead disable it by default to allow distros to
> > unconditionally enable DMAR support.
> 
> Acked-By: David Woodhouse <David.Woodhouse@intel.com>

Ok, I've picked that up into my drm-intel-fixes tree and will send it off
to Dave in the next few days.

> It *really* winds me up that we never bother to test this hardware
> before we ship it.
> 
> But I'm even *more* disappointed that we can't even diagnose it and
> publish coherent errata *after* the fact. I'd really like to see each
> quirk which disables features referencing a specific published erratum.
> We really ought to be able to manage at least *that* much.
> 
> Rajesh?

Yeah, some real quirk notice would be nice. I've hunted down the gen4
errata sheets, but there's nothing in there about the gfx not working for
dmar. Hence I'm opting for a working gpu in case of doubts.

Also note that according to intel docs only the gm45 and g45 have vt-d
support. So with this bug report we have them all covered. I've still left
all the other gen4 ids in the quirk tables, just in case intel marketing
materials win another round against me. Instead amended the commit message
a bit.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
