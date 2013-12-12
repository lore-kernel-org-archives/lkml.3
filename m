Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3LLVNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:13:44 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:47505 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3LLVNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:13:42 -0500
MIME-Version: 1.0
In-Reply-To: <20131212190659.GG13547@thunk.org>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
	<20131212190659.GG13547@thunk.org>
Date: Thu, 12 Dec 2013 13:13:41 -0800
X-Google-Sender-Auth: tCWw2mBbehQqIfyvmETCCWRtwnI
Message-ID: <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
Subject: Re: [PATCH 1/9] Known exploit detection
From: Kees Cook <keescook@chromium.org>
To: "Theodore Ts'o" <tytso@mit.edu>, vegard.nossum@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 11:06 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Dec 12, 2013 at 05:52:24PM +0100, vegard.nossum@oracle.com wrote:
>> From: Vegard Nossum <vegard.nossum@oracle.com>
>>
>> The idea is simple -- since different kernel versions are vulnerable to
>> different root exploits, hackers most likely try multiple exploits before
>> they actually succeed.

I like this idea. It serves a few purposes, not the least of which is
very clearly marking in code where we've had problems, regardless of
the fact that it reports badness to the system owner. And I think
getting any additional notifications about bad behavior is a nice idea
too.

> Suppose we put put this into the mainstream kernel.  Wouldn't writers
> of root kit adapt by checking for the kernel version to avoid checking
> for exploits that are known not work?  So the question is whether the
> additional complexity in the kernel is going to be worth it, since
> once the attackers adapt, the benefits of trying to detect attacks for
> mitigated exploits will be minimal.

This is already somewhat the case, but I think this idea still has
value. The reality of the situation is that the kernels running on an
end-user's system is rarely a stock upstream kernel. As a result, they
usually have organization-specific versioning, which makes
version-only autodetection useless to an attacker. While it is
possible to keep track of all distro versions in a massive table, even
the public exploits rarely do this, instead focusing on maybe one or
two distros. But when attacking systems with kernels built custom by
various organizations that don't publish their kernel trees, it
becomes impossible to rely on just the version. Given all the forks,
and stable vs mainline, and backported patches vs not, the version
tends to only give a gross ball-park idea. Probing is still useful to
an attacker, and this proposes reporting those probes.

I like it. I like how lightweight it is, and I like that it can be
trivially compiled out. My concerns would be:

- how do we avoid bikeshedding about which exploits are "serious
enough" to trigger a report?

- who will keep adding these triggers going forward?

I'm more than happy to assist with adding future triggers, but I don't
want to be the only person doing it. :)

-Kees

-- 
Kees Cook
Chrome OS Security
