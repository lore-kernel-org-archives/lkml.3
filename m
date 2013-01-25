Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3AYBqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:46:06 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:63080 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3AYBqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:46:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9tz6_=k1Ze5h2935-W59BCVy9KXA_z6t8inW6_-Cxw244Q@mail.gmail.com>
References: <alpine.DEB.2.00.1301250041001.25545@skynet.skynet.ie>
	<CA+55aFxzDv0emWgyde7iEWpgZarAGaExrKbEHFr-UcbhoeH_Cw@mail.gmail.com>
	<CAPM=9tz6_=k1Ze5h2935-W59BCVy9KXA_z6t8inW6_-Cxw244Q@mail.gmail.com>
Date: Fri, 25 Jan 2013 11:45:59 +1000
Message-ID: <CAPM=9txUNG_CeK+YBhcA_47BVv4Z2GAmEC_J59cY+D9nRgv54A@mail.gmail.com>
Subject: Re: [git pull] fbcon locking fixes.
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        m.b.lankhorst@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 11:06 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Fri, Jan 25, 2013 at 10:53 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, Jan 24, 2013 at 4:42 PM, Dave Airlie <airlied@linux.ie> wrote:
>>>
>>> These patches have been sailing around long enough, waiting for a maintainer
>>> to reappear, so I've decided enough is enough, lockdep is kinda useful to have.
>>
>> Last this was tried, these patches failed miserably.
>>
>> They caused instant lockdep splat and then a total lockup with efifb.
>> It may be that Takashi's patch helps fix that problem, but it's in no
>> way clear that it does, so the patch series isn't at all obviously
>> stable.
>>
>> Yes, lockdep is indeed "kinda useful", and there clearly are locking
>> problems in fbdev. But I'm not seeing myself pulling these for 3.8.
>> They've been too problematic to pull in at this late stage.
>>
>
> Okay I'll fix the efifb problem and then maybe queue them for -next.

Okay I've just sent out another fbcon patch to fix the locking harder.

There was a path going into set_con2fb_path if an fb driver was
already registered, I just pushed the locking out further on anyone
going in there.

it boots on my EFI macbook here.

Dave.
