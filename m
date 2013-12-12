Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3LLXzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:55:35 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64883 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3LLXze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:55:34 -0500
MIME-Version: 1.0
In-Reply-To: <52AA4BC8.1080207@gmail.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
	<20131212190659.GG13547@thunk.org>
	<CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
	<52AA4BC8.1080207@gmail.com>
Date: Thu, 12 Dec 2013 15:55:33 -0800
X-Google-Sender-Auth: AcivzbffQshdQG7ry5ZAtTKohkQ
Message-ID: <CAGXu5j+mutYTfWWQ0fiKiTkO-Owo6SrikT=xhTrSP+kaDQge8g@mail.gmail.com>
Subject: Re: [PATCH 1/9] Known exploit detection
From: Kees Cook <keescook@chromium.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, vegard.nossum@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
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

On Thu, Dec 12, 2013 at 3:50 PM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 13/12/13 08:13, Kees Cook wrote:
>> On Thu, Dec 12, 2013 at 11:06 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>>> On Thu, Dec 12, 2013 at 05:52:24PM +0100, vegard.nossum@oracle.com wrote:
>>>> From: Vegard Nossum <vegard.nossum@oracle.com>
>>>>
>>>> The idea is simple -- since different kernel versions are vulnerable to
>>>> different root exploits, hackers most likely try multiple exploits before
>>>> they actually succeed.
>>
>> I like this idea. It serves a few purposes, not the least of which is
>> very clearly marking in code where we've had problems, regardless of
>> the fact that it reports badness to the system owner. And I think
>> getting any additional notifications about bad behavior is a nice idea
>> too.
>
> Though, if an attacker is running through a series of exploits, and one
> eventually succeeds then the first thing to do would be to clean traces
> of the _exploit() notifications from the syslog. Since running through a
> series of exploits is pretty quick, this can probably all be done before
> the sysadmin ever notices.

Sure, but many organizations have centralized network syslog, so
unless the attack can spread to those machines too (which are usually
more locked down), the attacker will leave traces.

> The _exploit() notifications could also be used to spam the syslogs.
> Although they are individually ratelimited, if there are enough
> _exploit() markers in the kernel then an annoying person can cycle
> through them all to generate large amounts of useless syslog.

Totally true, but there's a million way to DoS a local machine. At
least this way shows who's doing it. It's the DoSes that don't include
attribution that I worry about. :)

-Kees

-- 
Kees Cook
Chrome OS Security
