Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3LMSOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 13:14:44 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:40525 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3LMSOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 13:14:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKOvngwCStCabR7wK0wwcu2H4eTz7=29FbbBWdGpoC78g@mail.gmail.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
	<20131212190659.GG13547@thunk.org>
	<CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
	<20131213002523.GA20706@redhat.com>
	<20131213014220.GB11068@kroah.com>
	<CAGXu5jKOvngwCStCabR7wK0wwcu2H4eTz7=29FbbBWdGpoC78g@mail.gmail.com>
Date: Fri, 13 Dec 2013 10:14:42 -0800
X-Google-Sender-Auth: z9jers32mxgSKSjt5mDVT8BuXE8
Message-ID: <CA+55aFxKsaRFR=Tjs9VJfFk3X4USbGWOvNrMg7BQYv7VX28_zQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] Known exploit detection
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        vegard.nossum@oracle.com, LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 9:58 AM, Kees Cook <keescook@chromium.org> wrote:
>
> These locations tend to be very hard to reach accidentally

Not necessarily.

Don't get me wrong - I think that it's a good idea to at least have
the option to complain about certain errors, and leave markers in the
logs about things that look suspicious.

But looking through the recent list of commits that explicitly mention
a CVE, the only one I find where a syslog message would make sense is
the HID validation ones. There, adding a warning about malicious HID
devices sounds like a good idea.

But a *lot* of the rest is just checking ranges or making sure we have
proper string handling etc that just wouldn't be practical to check.
So the error itself may be "hard to reach accidentally", but
*checking* it would be so complex/painful that it would likely just
introduce more room for bugs.

So I think the "WARNING" thing is a good idea, but I think it is a
good idea if it's used very judiciously. IOW, not for "random CVE"
(because quite frankly, most of them seem to be utter shit), but for
serious known issues. And for those issues *only*.

If I start seeing patches adding warnings "just because there's a
CVE", then I'm not in the least interested. But if there is some known
root-kit or similar, then by all means..

                    Linus
