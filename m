Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3ISSct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:32:49 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:53682 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3ISScs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:32:48 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Dave Airlie <airlied@gmail.com>
CC: "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Regression: bisected: commit 7c510133d93 breaks video
Thread-Topic: Regression: bisected: commit 7c510133d93 breaks video
Thread-Index: Ac603Dj75+4o5NvZQwiCa9lQKGnjBAAP/hCAABH+RhAAAI6esA==
Date: Thu, 19 Sep 2013 18:32:47 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458E042D4@US01WEMBX2.internal.synopsys.com>
References: <A2CA0424C0A6F04399FB9E1CD98E030458E03F28@US01WEMBX2.internal.synopsys.com>
 <CAPM=9txFE7=e47oY0rqe29DYva2T2MtKHgTjKBtuLfOaNZebZg@mail.gmail.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Paul Zimmerman
> Sent: Thursday, September 19, 2013 11:21 AM
> 
> > From: Dave Airlie [mailto:airlied@gmail.com]
> > Sent: Wednesday, September 18, 2013 7:40 PM
> >
> > On Thu, Sep 19, 2013 at 12:02 PM, Paul Zimmerman
> > <Paul.Zimmerman@synopsys.com> wrote:
> > > I have an ASUS P6X58D-Premium mobo with a GeForce 9400GT PCIe video card.
> > > With kernel 3.12-rc1, I get scrambled video on boot. Kernel 3.11 works
> > > fine.
> > >
> > > Bisecting this, I found 7c510133d93dd6f15ca040733ba7b2891ed61fd1 "drm:
> > > mark context support as a legacy subsystem" is the guilty commit. If I
> > > revert that commit, the video works fine.
> > >
> > > Is there any more info I can provide?
> >
> > Full dmesg, and what driver you are using.
> 
> Driver is nouveau.
> 
> The dmesg from a good boot with the commit reverted is attached.
> 
> For the bad boot, the dmesg log is filled with messages like this:
> 
> [   15.871667] nouveau E[     PFB][0000:03:00.0] trapped write at 0x01010010a0 on channel 0x0001fed0
> [unknown] BAR/PFIFO_WRITE/IN reason: PAGE_NOT_PRESENT
> [   15.871698] nouveau E[     PFB][0000:03:00.0] trapped write at 0x010100b2e0 on channel 0x0001fed0
> [unknown] BAR/PFIFO_WRITE/IN reason: PAGE_NOT_PRESENT
> [   15.871781] nouveau E[     PFB][0000:03:00.0] trapped write at 0x0101011600 on channel 0x0001fed0
> [unknown] BAR/PFIFO_WRITE/IN reason: PAGE_NOT_PRESENT
> 
> I will try next with the patch series you sent to Linus yesterday, to
> see if that happens to fix this.

Nope, with your patch series from yesterday the problem still exists.

-- 
Paul

