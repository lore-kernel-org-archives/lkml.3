Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab3ISVUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:20:30 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34158 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3ISVU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458E04369@US01WEMBX2.internal.synopsys.com>
References: <A2CA0424C0A6F04399FB9E1CD98E030458E03F28@US01WEMBX2.internal.synopsys.com>
	<CAPM=9txFE7=e47oY0rqe29DYva2T2MtKHgTjKBtuLfOaNZebZg@mail.gmail.com>
	<A2CA0424C0A6F04399FB9E1CD98E030458E042D4@US01WEMBX2.internal.synopsys.com>
	<20130919201058.GD32145@phenom.ffwll.local>
	<CAPM=9twVBn3EMt2RwQHBZBNV+6iYBKbYTGNbiOsnKnRA+dpyKw@mail.gmail.com>
	<A2CA0424C0A6F04399FB9E1CD98E030458E04369@US01WEMBX2.internal.synopsys.com>
Date: Fri, 20 Sep 2013 07:20:27 +1000
Message-ID: <CAPM=9tzPVYcyADMKvFGwi+RQVpmmB2oD2Jjx9OFZmSeisu6VXg@mail.gmail.com>
Subject: Re: Regression: bisected: commit 7c510133d93 breaks video
From: Dave Airlie <airlied@gmail.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 7:13 AM, Paul Zimmerman
<Paul.Zimmerman@synopsys.com> wrote:
>> From: Dave Airlie [mailto:airlied@gmail.com]
>> Sent: Thursday, September 19, 2013 1:15 PM
>>
>> On Fri, Sep 20, 2013 at 6:10 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
>> > On Thu, Sep 19, 2013 at 06:32:47PM +0000, Paul Zimmerman wrote:
>> >> > From: Paul Zimmerman
>> >> > Sent: Thursday, September 19, 2013 11:21 AM
>> >> >
>> >> > > From: Dave Airlie [mailto:airlied@gmail.com]
>> >> > > Sent: Wednesday, September 18, 2013 7:40 PM
>> >> > >
>> >> > > On Thu, Sep 19, 2013 at 12:02 PM, Paul Zimmerman
>> >> > > <Paul.Zimmerman@synopsys.com> wrote:
>> >> > > > I have an ASUS P6X58D-Premium mobo with a GeForce 9400GT PCIe video card.
>> >> > > > With kernel 3.12-rc1, I get scrambled video on boot. Kernel 3.11 works
>> >> > > > fine.
>> >> > > >
>> >> > > > Bisecting this, I found 7c510133d93dd6f15ca040733ba7b2891ed61fd1 "drm:
>> >> > > > mark context support as a legacy subsystem" is the guilty commit. If I
>> >> > > > revert that commit, the video works fine.
>> >> > > >
>> >> > > > Is there any more info I can provide?
>> >> > >
>> >> > > Full dmesg, and what driver you are using.
>> >> >
>> >> > Driver is nouveau.
>> >> >
>> >> > The dmesg from a good boot with the commit reverted is attached.
>> >> >
>> >> > For the bad boot, the dmesg log is filled with messages like this:
>> >> >
>> >> > [   15.871667] nouveau E[     PFB][0000:03:00.0] trapped write at 0x01010010a0 on channel
>> 0x0001fed0
>> >> > [unknown] BAR/PFIFO_WRITE/IN reason: PAGE_NOT_PRESENT
>> >> > [   15.871698] nouveau E[     PFB][0000:03:00.0] trapped write at 0x010100b2e0 on channel
>> 0x0001fed0
>> >> > [unknown] BAR/PFIFO_WRITE/IN reason: PAGE_NOT_PRESENT
>> >> > [   15.871781] nouveau E[     PFB][0000:03:00.0] trapped write at 0x0101011600 on channel
>> 0x0001fed0
>> >> > [unknown] BAR/PFIFO_WRITE/IN reason: PAGE_NOT_PRESENT
>> >> >
>> >> > I will try next with the patch series you sent to Linus yesterday, to
>> >> > see if that happens to fix this.
>> >>
>> >> Nope, with your patch series from yesterday the problem still exists.
>> >
>> > Just to double-check: Does the revert still work, even on latest upstream
>> > git + Dave's pull request?
>>
>> Also what versions of userspace have you got, libdrm +
>> xf86-video-nouveau and mesa?
>
> Yes, the revert still works.
>
> I have pretty old userspace, Fedora 14.
>
> libdrm is 2.4.22-1.fc14, mesa is 7.9-5.fc14.
>
> I don't have xf86-video-nouveau, I have
> xorg-x11-drv-nouveau.x86_64 1:0.0.16-14.20101010git8c8f15c.fc14

Okay it all makes sense now!

I'll revert the patch upstream then, older nouveau userspace used
contexts, for what reason I've no idea :-)

Dave.
