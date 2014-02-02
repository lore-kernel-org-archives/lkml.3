Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaBBR5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 12:57:42 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55295 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751882AbaBBR5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 12:57:41 -0500
Date: Sun, 2 Feb 2014 17:57:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 09/23] drm/i2c: tda998x: don't read write-only
	registers
Message-ID: <20140202175736.GH26684@n2100.arm.linux.org.uk>
References: <cover.1390986082.git.moinejf@free.fr> <5269e596e16dfe40253dce38ceb0dc4a617384c1.1390986083.git.moinejf@free.fr> <20140202162309.GF26684@n2100.arm.linux.org.uk> <20140202184512.7fa2e3cf@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140202184512.7fa2e3cf@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 02, 2014 at 06:45:12PM +0100, Jean-Francois Moine wrote:
> On Sun, 2 Feb 2014 16:23:09 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Sat, Jan 25, 2014 at 06:14:42PM +0100, Jean-Francois Moine wrote:  
> > > This patch takes care of the write-only registers of the tda998x.
> > > 
> > > The registers SOFTRESET, TBG_CNTRL_0 and TBG_CNTRL_1 have all bits
> > > cleared after reset, so, they may be fully re-written.
> > > 
> > > The register MAT_CONTRL is set to
> > > 	MAT_CONTRL_MAT_BP | MAT_CONTRL_MAT_SC(1)
> > > after reset, so, it may be fully set again to this value.  
> > 
> > I said in v3 of this patch, which seems to remain unaddressed:
> >   
> > >       /* must be last register set: */
> > > -     reg_clear(priv, REG_TBG_CNTRL_0, TBG_CNTRL_0_SYNC_ONCE);
> > > +     reg_write(priv, REG_TBG_CNTRL_0, 0);  
> > 
> > Register changes which have a potential effect shouldn't be part of a
> > patch which is really only trying to avoid reading from write only
> > registers.
> > 
> > This could be a potential functional change - and it's probably one
> > which Rob Clark should at least be made aware of.  As I commented last
> > time, when you're changing register values in an otherwise innocuous
> > patch, you should comment about them in the patch description.  
> 
> According to the tda9983b documentation, the register TBG_CNTRL_0 is
> set to 0 at reset time. I think that it is the same for all the tda998x
> family. In the other hand, this register is supposed to be write only,
> so reading it may return any value, and the reg_clear() function may
> set any other bits. Then, clearing one bit is less secure than clearing
> the full register.

Okay, in that case I'm happy with this patch.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
