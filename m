Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965886AbaFTIYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:24:21 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:61596 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874AbaFTIYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:24:16 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53A366B3.8020808@zytor.com>
References: <20140618102957.15728.43525.stgit@patser>
	<20140618103653.15728.4942.stgit@patser>
	<20140619011327.GC10921@kroah.com>
	<CAF6AEGv4Ms+zsrEtpA10bGq04LnRjzVb925co49eVxh4ugkd=A@mail.gmail.com>
	<20140619170059.GA1224@kroah.com>
	<CAKMK7uFa57YjeJCFQhWFr_5cRTTpWxBdJ1qtb5Ojnu-KZpe-Lw@mail.gmail.com>
	<20140619200159.GA27883@kroah.com>
	<53A366B3.8020808@zytor.com>
Date: Fri, 20 Jun 2014 10:24:15 +0200
X-Google-Sender-Auth: dqHJT_ass7f4FPDnwgZrMZuiHno
Message-ID: <CAKMK7uGXHoUfWOGMH9EzbuZHKxLdLznUXLfq=USs6T=jkryYgg@mail.gmail.com>
Subject: Re: [REPOST PATCH 1/8] fence: dma-buf cross-device synchronization (v17)
From: Daniel Vetter <daniel@ffwll.ch>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Rob Clark <robdclark@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        "open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Colin Cross <ccross@google.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 12:39 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> Aside: This is a pet peeve of mine and recently I've switched to
>>> rejecting all patch that have a BUG_ON, period.
>>
>> Please do, I have been for a few years now as well for the same reasons
>> you cite.
>>
>
> I'm actually concerned about this trend.  Downgrading things to WARN_ON
> can allow a security bug in the kernel to continue to exist, for
> example, or make the error message disappear.
>
> I am wondering if the right thing here isn't to have a user (command
> line?) settable policy as to how to proceed on an assert violation,
> instead of hardcoding it at compile time.

I should clarify: If it smells like the issue is a failure of our
ioctl/syscall validation code to catch crap, BUG_ON is the right
choice. And fundamentally I've had this rule since 1-2 years now, the
only recent change I've done is switch my scripts from warning by
default if there's a new BUG_ON to rejecting by default. Mostly
because I'm lazy and let too many BUG_ONs pass through by default.

Also if you add a new interface to i915 I'll make damn sure you supply
a full set of nasty testcases to abuse the ioctl hard. In the end it's
a tradeoff and overall I don't think I'm compromising security with my
current set of rules.

Also, people don't (yet) terribly care about data integrity as soon as
their data has passed once through a gpu.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
