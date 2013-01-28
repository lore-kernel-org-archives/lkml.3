Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3A1Mp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:45:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34410 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab3A1Mpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:45:55 -0500
Message-ID: <51067300.2050808@canonical.com>
Date: Mon, 28 Jan 2013 13:45:52 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, m.b.lankhorst@gmail.com,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] fbcon locking fixes.
References: <alpine.DEB.2.00.1301250041001.25545@skynet.skynet.ie> <CA+55aFxzDv0emWgyde7iEWpgZarAGaExrKbEHFr-UcbhoeH_Cw@mail.gmail.com> <CAPM=9tz6_=k1Ze5h2935-W59BCVy9KXA_z6t8inW6_-Cxw244Q@mail.gmail.com> <CAPM=9txUNG_CeK+YBhcA_47BVv4Z2GAmEC_J59cY+D9nRgv54A@mail.gmail.com>
In-Reply-To: <CAPM=9txUNG_CeK+YBhcA_47BVv4Z2GAmEC_J59cY+D9nRgv54A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 25-01-13 02:45, Dave Airlie schreef:
> On Fri, Jan 25, 2013 at 11:06 AM, Dave Airlie <airlied@gmail.com> wrote:
>> On Fri, Jan 25, 2013 at 10:53 AM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> On Thu, Jan 24, 2013 at 4:42 PM, Dave Airlie <airlied@linux.ie> wrote:
>>>> These patches have been sailing around long enough, waiting for a maintainer
>>>> to reappear, so I've decided enough is enough, lockdep is kinda useful to have.
>>> Last this was tried, these patches failed miserably.
>>>
>>> They caused instant lockdep splat and then a total lockup with efifb.
>>> It may be that Takashi's patch helps fix that problem, but it's in no
>>> way clear that it does, so the patch series isn't at all obviously
>>> stable.
>>>
>>> Yes, lockdep is indeed "kinda useful", and there clearly are locking
>>> problems in fbdev. But I'm not seeing myself pulling these for 3.8.
>>> They've been too problematic to pull in at this late stage.
>>>
>> Okay I'll fix the efifb problem and then maybe queue them for -next.
> Okay I've just sent out another fbcon patch to fix the locking harder.
>
> There was a path going into set_con2fb_path if an fb driver was
> already registered, I just pushed the locking out further on anyone
> going in there.
>
> it boots on my EFI macbook here.
>
I cherry picked those patches to my tree, and the full series no longer triggers a lockdep warning.
It also no longer locks up during modprobing or vga-switcheroo either.

Tested-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

~Maarten
