Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaIAGSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:18:39 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:61679 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaIAGSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:18:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAGUYZuRwKXyRuYg1xDB9u1gE4gTRcpV_c_O645N8V-yksSfsNQ@mail.gmail.com>
References: <1407731491-22446-1-git-send-email-linux@roeck-us.net>
	<alpine.DEB.2.02.1408110439580.15519@chino.kir.corp.google.com>
	<CAGUYZuS=_rFpukssRebxXBccPrJAen15i8Qf3K+1YyF+feShdQ@mail.gmail.com>
	<CAGUYZuSk4u5jyPcrYTjwjXmQRyr0kCEvxkgFfjcyP+ex544CLA@mail.gmail.com>
	<alpine.DEB.2.02.1408111352090.24240@chino.kir.corp.google.com>
	<CAF6AEGuu7cGpudV-G=vGCZrHjEuqTcFHsqnULE771a5UMNEVsw@mail.gmail.com>
	<alpine.DEB.2.02.1408111636370.23479@chino.kir.corp.google.com>
	<20140812065516.GI10500@phenom.ffwll.local>
	<CAGUYZuRwKXyRuYg1xDB9u1gE4gTRcpV_c_O645N8V-yksSfsNQ@mail.gmail.com>
Date: Mon, 1 Sep 2014 16:18:35 +1000
Message-ID: <CAPM=9tz5wBWt88DbddWL8WZL-=WKLFP3LtjdjY2VUJXBQ=O7Lw@mail.gmail.com>
Subject: Re: [PATCH] drm: Do not use BUG_ON(!spin_is_locked())
From: Dave Airlie <airlied@gmail.com>
To: sanjeev sharma <sanjeevsharmaengg@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Rob Clark <robdclark@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>ssert_spin_locked() is a better option.
>> > >
>> >
>> > Unless there's a bug, assert_spin_locked() is just going to incur an
>> > unnecessary cost every time it is called at runtime.  My suggestion was
>> > to
>> > limit that check only to debugging kernels that include enabling lockdep
>> > when tracking down problems rather than needlessly evaluating the
>> > conditional every time when there are no bugs.
>>
>> My experience with gpu drivers (i915) has been that hw and the software
>> running it is varied enough that almost always it's better to
>> unconditionally enable this stuff. I much prefer assert_spin_locked and
>> friends over the lockdep versions since enabling full lockdep is not
>> something you usually do. Especially not normal users, and we rely upon
>> them for testing the old stuff. Furthermore for the modeset code the
>> overhead is totally irrelevant since we're doing metric piles of register
>> reads and writes in there anyway.


Did anything translate into an R-b here?

Dave.
