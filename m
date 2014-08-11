Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaHKXJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 19:09:06 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:54676 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaHKXJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 19:09:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1408111352090.24240@chino.kir.corp.google.com>
References: <1407731491-22446-1-git-send-email-linux@roeck-us.net>
	<alpine.DEB.2.02.1408110439580.15519@chino.kir.corp.google.com>
	<CAGUYZuS=_rFpukssRebxXBccPrJAen15i8Qf3K+1YyF+feShdQ@mail.gmail.com>
	<CAGUYZuSk4u5jyPcrYTjwjXmQRyr0kCEvxkgFfjcyP+ex544CLA@mail.gmail.com>
	<alpine.DEB.2.02.1408111352090.24240@chino.kir.corp.google.com>
Date: Mon, 11 Aug 2014 19:09:03 -0400
Message-ID: <CAF6AEGuu7cGpudV-G=vGCZrHjEuqTcFHsqnULE771a5UMNEVsw@mail.gmail.com>
Subject: Re: [PATCH] drm: Do not use BUG_ON(!spin_is_locked())
From: Rob Clark <robdclark@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: sanjeev sharma <sanjeevsharmaengg@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 4:53 PM, David Rientjes <rientjes@google.com> wrote:
> On Mon, 11 Aug 2014, sanjeev sharma wrote:
>
>> Hello David,
>>
>> Here is the old discussion carried out on this.
>>
>> http://linux-kernel.2935.n7.nabble.com/Is-spin-is-locked-safe-to-use-with-BUG-ON-WARN-ON-td654800.html#a921802
>>
>
> I'm suggesting that if you don't want to incur the cost of the conditional
> everytime you call a certain function with assert_spin_locked() that you
> could covert these to lockdep_assert_held() so the check is only done when
> lockdep is enabled for debugging.

not sure about the nouveau parts, but for the omap and msm hunks, this
code getting called at potentially vblank rate (so maybe once or twice
per ~16ms)..  and lockdep has considerable overhead (for a gpu driver)
so I don't always have it enabled.  So it sounds like for those two at
least assert_spin_locked() is a better option.

BR,
-R

> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
