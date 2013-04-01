Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab3DAW6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:58:10 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:38504 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976Ab3DAW6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:58:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130401223500.GB2487@htj.dyndns.org>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
 <CAAAKZwv9=NFmt6xj1KF2va1i6=UCvka0YkmdOY9JNUMHDOWpGw@mail.gmail.com>
 <20130401184617.GB31435@htj.dyndns.org> <CAAAKZwvemKDLeuKr6wWMUSVczkRVDZKSzYrXXEMcZ8qvcFR0zQ@mail.gmail.com>
 <20130401202943.GC31435@htj.dyndns.org> <CAAAKZwuZwN68vtk1qO08GXB_OnQNVtqqp+v_NQfP27W0P_aWZw@mail.gmail.com>
 <20130401220309.GA2487@htj.dyndns.org> <CAAAKZwuev7Y58ZQNtG+XdFRt0=NedD7zbYTAZbJ95ahBKLVhKA@mail.gmail.com>
 <20130401223500.GB2487@htj.dyndns.org>
From: Tim Hockin <thockin@hockin.org>
Date: Mon, 1 Apr 2013 15:57:46 -0700
X-Google-Sender-Auth: lqER9lCUyxEb1tTqpS5Wvl6Hz-U
Message-ID: <CAAAKZwvdMUAZ+N5d-cdCJbKUq=t9M6BbCxzOTWnVQQBrg55vhw@mail.gmail.com>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v8
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 3:35 PM, Tejun Heo <tj@kernel.org> wrote:
> Hey,
>
> On Mon, Apr 01, 2013 at 03:20:47PM -0700, Tim Hockin wrote:
>> > Ummmm.... so that's why you guys can't use kernel memory limit? :(
>>
>> Because it is completely non-obvious how to map between the two in a
>> way that is safe across kernel versions and not likely to blow up in
>> our faces.  It's a hack, in other words.
>
> Now we're repeating the argument Frederic and Johannes had, so I'd
> suggest going back the thread and reading the discussion and if you
> still think using kmemcg is a bad idea, please explain why that is so.
> For the specific point that you just raised, the scale tilted toward
> thread/process count is a hacky and unreliable representation of
> kernel memory resource than the other way around, at least back then.

I am not limited by kernel memory, I am limited by PIDs, and I need to
be able to manage them.  memory.kmem.usage_in_bytes seems to be far
too noisy to be useful for this purpose.  It may work fine for "just
stop a fork bomb" but not for any sort of finer-grained control.

> If you think you can tilt it the other way, please feel free to try.

Just because others caved, doesn't make it less of a hack.  And I will
cave, too, because I don't have time to bang my head against a wall,
especially when I can see the remnants of other people who have tried.

We'll work around it, or we'll hack around it, or we'll carry this
patch in our own tree and just grumble about ridiculous hacks every
time we have to forward port it.

I was just hoping that things had worked themselves out in the last year.
