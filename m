Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3LMSHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 13:07:37 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:38821 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3LMSHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 13:07:36 -0500
MIME-Version: 1.0
In-Reply-To: <20131213052712.GH23888@thunk.org>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
	<20131212190659.GG13547@thunk.org>
	<CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
	<20131213052712.GH23888@thunk.org>
Date: Fri, 13 Dec 2013 10:07:35 -0800
X-Google-Sender-Auth: zYrY8-GV-D4BZ5ujSRbknovoZms
Message-ID: <CAGXu5jLghzKvLE0=ERQ10EZ_1GZ0642X6zr35EaSafq7WJ09Qw@mail.gmail.com>
Subject: Re: [PATCH 1/9] Known exploit detection
From: Kees Cook <keescook@chromium.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>,
        vegard.nossum@oracle.com, LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
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

On Thu, Dec 12, 2013 at 9:27 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Dec 12, 2013 at 01:13:41PM -0800, Kees Cook wrote:
>> > Suppose we put put this into the mainstream kernel.  Wouldn't writers
>> > of root kit adapt by checking for the kernel version to avoid checking
>> > for exploits that are known not work?  So the question is whether the
>> > additional complexity in the kernel is going to be worth it, since
>> > once the attackers adapt, the benefits of trying to detect attacks for
>> > mitigated exploits will be minimal.
>>
>> This is already somewhat the case, but I think this idea still has
>> value. The reality of the situation is that the kernels running on an
>> end-user's system is rarely a stock upstream kernel. As a result, they
>> usually have organization-specific versioning, which makes
>> version-only autodetection useless to an attacker.
>
> Most organizations can't afford to have an in-house kernel team
> providing specialized kernels for their server farms or their
> customized desktop distributions.  :-)
>
> Some places have publically said that they do this; Google has
> publically talked about Goobuntu and their data center production
> kernels, and some financial firms on Wall Street have boasted about
> how they run with a customized kernel --- although other financial
> firms have said they don't want to do that because they don't want to
> void their support contract with Red Hat or SuSE.  I suspect that at
> most shopes, though, the latter is going to be far more common than
> the former.

We can never really know, but given the evidence I've seen, there are
a lot of custom kernels out in the world. That combined with the fact
that sloppy attackers will still probe distro kernels, I think the
argument that "attackers will fall back to other detection mechanisms"
isn't strong enough to convince me that this series lacks value.

> Practically speaking, testing for various distribution kernel
> versions, as well as specific ChromeOS and Android kernel versions,
> wouldn't be that difficult for an attacker, and would probably allow
> them to avoid detection for 99% of the Linux systems found in the
> wild.  It would certainly be useful for detecting attempted attacks
> for private kernels where the configuration and security patches
> applied for some internal kernel are not public --- and if that caused
> the botnet author to be paranoid enough to avoid attacking machines
> which didn't have a known distribution kernel that definitely had that
> vulnerability, it would certainly be good for people running their own
> privately maintained kernel image.  So if this increases the market
> demand for kernel programmers, that's a good thing, right?   :-)

The careful attackers can successfully probe a system without needing
uname at all. These patches won't help against them.

-Kees

-- 
Kees Cook
Chrome OS Security
