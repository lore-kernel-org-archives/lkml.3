Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936000Ab3BTUTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:19:07 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:50280 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935336Ab3BTUTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:19:02 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CANeU7QnMzYuG6iiU3nLh4k0dGFMEDOyfUDQgxQSKj20_y-oL+Q@mail.gmail.com>
References: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com>
	<20130219100849.72d2330b@jbarnes-desktop>
	<CANeU7QmJb+yUGu9mVgq=_pHhvpPu6ORrikm=E6PkuHpOz9OREA@mail.gmail.com>
	<20130219125217.6b6f55ff@jbarnes-desktop>
	<CANeU7QnQmKYXHA=aEuRGZDc7hVdY6037i=+s_n3FZNMN2njDsw@mail.gmail.com>
	<CAKMK7uG7TgiAn0ZQ=E_-QBPNAVhTSxpORkX3Z1mY=54mgTzM-g@mail.gmail.com>
	<CANeU7QnMzYuG6iiU3nLh4k0dGFMEDOyfUDQgxQSKj20_y-oL+Q@mail.gmail.com>
Date: Wed, 20 Feb 2013 21:19:01 +0100
Message-ID: <CAKMK7uGDpSKga9=2SrGQDxBGzY5B1cGJAchZvfKfQy1ivRONMg@mail.gmail.com>
Subject: Re: i915 black screen introduced by ACPI changes
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Chris Li <lkml@chrisli.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        robert.moore@intel.com, feng.tang@intel.com, len.brown@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 8:45 PM, Chris Li <lkml@chrisli.org> wrote:
> On Wed, Feb 20, 2013 at 2:57 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
>> Starts to smell like a bog-standard i915 black screen bug (albeit with
>> a strange cause for the regression). Can you please boot the broken
>> kernels again with drm.debug=0xe and grab the complete dmesg?
>> Depending upon how long it takes for your wifi to get up, you might
>> need to extend the log buffer, it dumps a lot.
>
> Here is the dmesg with "drm.debug=0xe". It is from the tip of git
> kernel. The computer has the black screen.
> Let me know what else do you need.

The debug option did not stick for some reason. Also you're hitting a
bunch of WARNs in our driver self-checks. Iirc those should be fixed
in the latest code. Can you please test with the latest
drm-intel-nightly branch from

http://cgit.freedesktop.org/~danvet/drm-intel

Also can you please attach a dmesg from a working kernel without the
i915.modeset=0 option?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
