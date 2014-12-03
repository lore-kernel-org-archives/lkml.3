Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaLCPWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:22:48 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:38522 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaLCPWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:22:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAEUsAPYthwHxopuiBcGg4_nnBDDsS2jrTw4pDFiov38awsFodA@mail.gmail.com>
References: <20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
	<20141202170407.GK25340@linux.vnet.ibm.com>
	<547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
	<20141202184202.GM25340@linux.vnet.ibm.com>
	<547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
	<20141202191143.GN25340@linux.vnet.ibm.com>
	<547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
	<20141202205636.GQ25340@linux.vnet.ibm.com>
	<547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
	<CA+55aFxdZjJprk8t9NxcZmewAAQ5Gf1XQWV=5i+Vfc5uTSfWFg@mail.gmail.com>
	<547e81ce.a1628c0a.4985.ffffb12a@mx.google.com>
	<CA+55aFxumSXif01LigHBgZeXFTWT-7knX=a8LJZeaZZDPoHCBg@mail.gmail.com>
	<CAEUsAPYthwHxopuiBcGg4_nnBDDsS2jrTw4pDFiov38awsFodA@mail.gmail.com>
Date: Wed, 3 Dec 2014 07:22:44 -0800
X-Google-Sender-Auth: XcPDwQZjlHklZwNwRrXTbN82r8A
Message-ID: <CA+55aFyBgyRS0zeE+LuHAvc=54v0de2KX=hRnr3imXwFFbftXw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Rorvick <chris@rorvick.com>
Cc: =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 10:02 PM, Chris Rorvick <chris@rorvick.com> wrote:
>
>> while a "good" _before_ a subsequent bad is
>> also trustworthy (because if the "good" kernel contained the bug and
>> you should have marked it bad, we'd then go on to test all the commits
>> that were *not* the bug, so we'd never see a "bad" kernel again).
>
> wouldn't marking a bad commit "good" cause you to not see a *good*
> kernel again?  Marking it "good" would seem push the search away from
> the bug toward the current "bad" commit.

Yes, you're right.

The "long series of 'good'" at the end actually implies that the last
'bad' is questionable - just marking a bad kernel as being good should
push us further into 'bad' land, not the other way around. While
marking a 'good' kernel as 'bad' will push us into 'bug hasn't
happaned yet' land.

Which is somewhat odd, because the bad kernels should be easy to spot.
But it could happen if screwing up the test (by not booting the right
kernel, for example.

Or - and this is the scary part, and one of the huge downsides of 'git
bisect' - it just ends up meaning that the bug comes and goes and is
not quite repeatable enough.

Anyway, Dâniel, if you restart the bisection today, start it one
kernel earlier: re-test the last 'bad' kernel too. So start with
reconfirming that the c9b88e958182 kernel was bad (that *might* be as
easy as just checking your old kernel boot logs, and verifying that
"yes, I really booted it, and yes, it clearly hung and I had to
hard-reboot into it")

                   Linus
