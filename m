Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3C1UNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:13:47 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:35867 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3C1UNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:13:45 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 28 Mar 2013 13:13:23 -0700
X-Google-Sender-Auth: SI2ji69xR47ZcRvy2S6p5CHwXPg
Message-ID: <CAB=NE6WLuz7-QD3v4BwZkLLNUed=X7jgvZtZX8cDEh3HiD51oQ@mail.gmail.com>
Subject: Possibility for an external staging tree - bring up quality code
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kalle Valo <kvalo@adurom.com>, Jouni Malinen <j@w1.fi>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Kathy Giori <Kathy.Giori@qca.qualcomm.com>,
        Mathieu Olivari <mathieu@qca.qualcomm.com>,
        Yanbo Li <dreamfly281@gmail.com>, k.eugene.e@gmail.com,
        Adrian Chadd <adrian@freebsd.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, folks,

So the staging area of the Linux kernel has proven quite successful
for a few drivers for 802.11 already. Otus [0] for example was
rewritten completely first as ar9170 [1] and then carl9170 [2] even
with open firmware, carl9170.fw [3] and then Otus got nuked. ath6kl
[4] is another example, it got a lot of heavy handing on staging and
then Kalle took over and decided to work on the tree outside of the
kernel given that he was actually familiar with upstream requirements,
he just needed a lot more freedom than what we allow for patches
upstream to do a lot of heavy handing cleanup.

So staging helps a lot with drivers that likely get a little attention
or to help educate developers or vendors not used to upstream
development, but for experienced upstream developers that don't need
these lessons its a bit of a arm twister (although still good
practice) to deal with the requirements of patches upstream for a huge
cleanup. Granted keeping the history is good and important, specially
if accepting patches and so on, but at least from what I'm seeing some
802.11 developers are preferring to do the staging outside of the
Linux kernel. For both of these drivers then the main usage of staging
was as immediate enablement for users given that otherwise other Linux
distributions would cherry pick these drivers anyway and stable fixes
for these users, but for development experienced 802.11 developers
have used it only as a base to fork and do major overhauls. That was
the case for both otus and ath6kl and from the looks of it it seems
that the same is being preferred for the wcn36xx driver [5] which is a
clean rewrite of prima driver [6]. There are also some drivers on my
radar that I think might take similar approach, but not because they
are crap but still because they are still real staging drivers.

Despite these things some folks may want them. For example the
Wilocity 60 GHz 802.11ad wil6210 [8] driver was desired just for
monitor mode support as soon as that was supported and we wanted those
folks to be able to get it through a unified, and yet
upstream-prioritizing-friendly-fassion. Obviously no one runs the
latest foo-next subsystem kernels unless you are a developer so we
backport these drivers through compat-drivers [7]. For a while I
accepted these drivers into compat-drivers as a patch under crap/ with
the caveat that I'd kick them out after a kernel release or two if
they were not upstream by then. The maintenance of such drivers proved
painful, so I decided to kick them all out and push everyone to
usptream ASAP. That worked for wil6210, now upstrea, but for the
Ethernet alx driver [9], based on community feedback, still requires
more work. The crux of the alx driver was to either go to staging or
keep it externally for whatever reason. I was fan of just getting it
under staging but at that point I started addressing driver code
quality in general at corporations with Adrian [10] who works on
FreeBSD. If we can address code quality at large from inception, from
bring up code, then we'd all be in a better place. This experience has
been very educational given that it has brought up general bring up
considerations and timeline considerations for code and hardware. We
have to separate all these. We are currently testing an idea to use a
unified driver strategy for both FreeBSD and Linux under a unified
driver git tree for both which would never put in compromise the
upstream requirements for both. The idea is to do the staging
development companies typically do on their end publicly and address
their idea of unification *with* the community [11]. We chose alx
given the simplicity of the driver but work is going slow there. While
we give some time for that work to brew I have integrated it to
compat-drivers by extracting code using a reference git tree, this
lets the driver always have to deal with only linux-next being the
target and we'd deal with the backporting through compat-drivers and
compat. I will kick the alx driver out of compat-drivers though if we
don't get any unification interest from FreeBSD though, but this
experience has helped so far.

The issue of staging and bring up still exists and another drivers is
on the roadmap that is already sort of upstream quality but developers
would prefer to do development outside of drivers/staging/ to simply
address proper upstream as an ultimate objective given the major
overhauls required still and given the developers involved are
experienced upstream developers. The question of enablement to end
users of that driver comes up and I now have to consider adding cherry
picking drivers of that type to compat-drivers or simply asking for
folks to wait until its upstream. This has me thinking if it makes
sense to have an external driver tree for staging drivers but lead by
engineers who already know the rules of upstream, they just want to
get things done faster. Wanted to get your and the community's
feedback on this.

[0] http://wireless.kernel.org/en/users/Drivers/otus
[1] http://wireless.kernel.org/en/users/Drivers/ar9170
[2] http://wireless.kernel.org/en/users/Drivers/carl9170
[3] http://wireless.kernel.org/en/users/Drivers/carl9170.fw
[4] http://wireless.kernel.org/en/users/Drivers/ath6kl
[5] https://github.com/KrasnikovEugene/wcn36xx
[6] https://www.codeaurora.org/gitweb/external/wlan/?p=prima.git
[7] https://backports.wiki.kernel.org
[8] http://wireless.kernel.org/en/users/Drivers/wil6210
[9] http://www.linuxfoundation.org/collaborate/workgroups/networking/alx
[10] http://www.do-not-panic.com/2013/03/killing-proprietary-drivers-for-all.html
[11] http://lists.infradead.org/mailman/listinfo/unified-drivers

  Luis
