Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbbAMOTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:19:53 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:57367 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbbAMOTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:19:51 -0500
MIME-Version: 1.0
In-Reply-To: <54B527E8.3080004@osg.samsung.com>
References: <cover.1421115389.git.shuahkh@osg.samsung.com>
	<515f84cc1e6e33f647610f1bda154127944e6b52.1421115389.git.shuahkh@osg.samsung.com>
	<CAGoCfixdyOJoyUQfMWzM2KHjMGJE5pRS8C0+rR1nDCir7jTpwQ@mail.gmail.com>
	<54B527E8.3080004@osg.samsung.com>
Date: Tue, 13 Jan 2015 09:19:50 -0500
Message-ID: <CAGoCfix=fEj5SMqBh_bwzRTfqSkM03jiKbp6-jW9u4CLf6ffSg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] media: au0828 remove video and vbi buffer timeout work-around
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tim Mester <ttmesterr@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I couldn't reproduce what I was seeing when I did patch v2 series
> work. What I noticed was that I was seeing a few too many green screens
> and I had to re-tune xawtv when the timeout code is in place. My
> thinking was that this timeout handling could be introducing blank
> green frames when there is no need. However, I can't reproduce the
> problem on 3.19-rc4 base which is what I am using to test the changes
> to the patch series. Hence, I am not positive if the timeout code
> indeed was doing anything bad.

IIRC, the timer was set for 40ms, so if a complete video frame doesn't
arrive within that interval we generate a green frame.  It was never
really intended to have perfect clocking (i.e. 29.97 FPS), but is
really just there to prevent the tvtime user interface from blocking
indefinitely.

If you weren't seeing it in the V2 series, then I guess you fixed
whatever bug was present in V1.

> I am seeing tvtime hangs without the timeout. I am fine with this
> patch not going. It does make the code cleaner and also reduces
> buffer handling during streaming. However, there is a clear regression
> to tvtime.

Correct.  I think everybody agrees that the timer code is ugly and it
would be cleaner if it wasn't needed - except it clearly is needed to
prevent regressions in tvtime.

All that said, I'm quite excited to see the driver converted to VB2.  Nice job!

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
