Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3ISUKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 16:10:47 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56477 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab3ISUKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 16:10:46 -0400
Date: Thu, 19 Sep 2013 22:10:58 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Dave Airlie <airlied@gmail.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression: bisected: commit 7c510133d93 breaks video
Message-ID: <20130919201058.GD32145@phenom.ffwll.local>
Mail-Followup-To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
	Dave Airlie <airlied@gmail.com>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <A2CA0424C0A6F04399FB9E1CD98E030458E03F28@US01WEMBX2.internal.synopsys.com>
 <CAPM=9txFE7=e47oY0rqe29DYva2T2MtKHgTjKBtuLfOaNZebZg@mail.gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458E042D4@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458E042D4@US01WEMBX2.internal.synopsys.com>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 06:32:47PM +0000, Paul Zimmerman wrote:
> > From: Paul Zimmerman
> > Sent: Thursday, September 19, 2013 11:21 AM
> > 
> > > From: Dave Airlie [mailto:airlied@gmail.com]
> > > Sent: Wednesday, September 18, 2013 7:40 PM
> > >
> > > On Thu, Sep 19, 2013 at 12:02 PM, Paul Zimmerman
> > > <Paul.Zimmerman@synopsys.com> wrote:
> > > > I have an ASUS P6X58D-Premium mobo with a GeForce 9400GT PCIe video card.
> > > > With kernel 3.12-rc1, I get scrambled video on boot. Kernel 3.11 works
> > > > fine.
> > > >
> > > > Bisecting this, I found 7c510133d93dd6f15ca040733ba7b2891ed61fd1 "drm:
> > > > mark context support as a legacy subsystem" is the guilty commit. If I
> > > > revert that commit, the video works fine.
> > > >
> > > > Is there any more info I can provide?
> > >
> > > Full dmesg, and what driver you are using.
> > 
> > Driver is nouveau.
> > 
> > The dmesg from a good boot with the commit reverted is attached.
> > 
> > For the bad boot, the dmesg log is filled with messages like this:
> > 
> > [   15.871667] nouveau E[     PFB][0000:03:00.0] trapped write at 0x01010010a0 on channel 0x0001fed0
> > [unknown] BAR/PFIFO_WRITE/IN reason: PAGE_NOT_PRESENT
> > [   15.871698] nouveau E[     PFB][0000:03:00.0] trapped write at 0x010100b2e0 on channel 0x0001fed0
> > [unknown] BAR/PFIFO_WRITE/IN reason: PAGE_NOT_PRESENT
> > [   15.871781] nouveau E[     PFB][0000:03:00.0] trapped write at 0x0101011600 on channel 0x0001fed0
> > [unknown] BAR/PFIFO_WRITE/IN reason: PAGE_NOT_PRESENT
> > 
> > I will try next with the patch series you sent to Linus yesterday, to
> > see if that happens to fix this.
> 
> Nope, with your patch series from yesterday the problem still exists.

Just to double-check: Does the revert still work, even on latest upstream
git + Dave's pull request?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
