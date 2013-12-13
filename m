Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3LMR6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:58:50 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:42943 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab3LMR6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:58:48 -0500
MIME-Version: 1.0
In-Reply-To: <20131213014220.GB11068@kroah.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
	<20131212190659.GG13547@thunk.org>
	<CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
	<20131213002523.GA20706@redhat.com>
	<20131213014220.GB11068@kroah.com>
Date: Fri, 13 Dec 2013 09:58:48 -0800
X-Google-Sender-Auth: KfrFrBvc7tbIa75EerbCYfwyVyw
Message-ID: <CAGXu5jKOvngwCStCabR7wK0wwcu2H4eTz7=29FbbBWdGpoC78g@mail.gmail.com>
Subject: Re: [PATCH 1/9] Known exploit detection
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Jones <davej@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        vegard.nossum@oracle.com, LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 5:42 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Dec 12, 2013 at 07:25:23PM -0500, Dave Jones wrote:
>> On Thu, Dec 12, 2013 at 01:13:41PM -0800, Kees Cook wrote:
>>
>>  > - who will keep adding these triggers going forward?
>>
>> also..
>>
>> - Who will test the existing triggers are doing the right thing when related code changes.
>
> And:
>   - how do you determine an "expoit attempt" from "userspace program
>     doing something stupid" / "corrupted filesytem mounted"?
>
> I really don't like this, it means that our normal error handling for
> userspace data will suddenly all have CVE entries on them over time.
> How is that helpful to anyone?

These locations tend to be very hard to reach accidentally, or
userspace never exercised the path (which is why the flaws go
unnoticed usually). Having userspace trip over them is unlikely, so
we'd want to know about that anyway. If something actually turns
noisy, we drop it. But in at least the i915 case, it took seriously
careful work to hit the flawed code path.

> Think ahead in 10-20 years, what is the code paths going to look like
> then?  Horrible...

If we have that many CVE in the moving 5 year window, then we should
certainly feel worse about that reality than just having a few extra
lines in the code. :)

Keeping this up at the memory-corruption or permissions bypass level
means we won't annotate the vast majority of CVEs that are usually low
priority issues.

-Kees

-- 
Kees Cook
Chrome OS Security
