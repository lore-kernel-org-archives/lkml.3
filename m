Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3APKid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 05:38:33 -0500
Received: from canardo.mork.no ([148.122.252.1]:53814 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758752Ab3APKib convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 05:38:31 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        platform-driver-x86@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mattia Dongili <malattia@linux.it>
Subject: Re: [GIT] x86 platform driver bugfixes for 3.8
Organization: m
References: <20130107171722.GA31427@srcf.ucam.org>
	<CA+55aFzL00K+oURqcnSgbAAkD18DJ8-p1G8vd7KE6RD77dLmCQ@mail.gmail.com>
	<20130107172616.GB31427@srcf.ucam.org>
	<20130107174306.GC31427@srcf.ucam.org>
Date: Wed, 16 Jan 2013 11:38:17 +0100
In-Reply-To: <20130107174306.GC31427@srcf.ucam.org> (Matthew Garrett's message
	of "Mon, 7 Jan 2013 17:43:06 +0000")
Message-ID: <87ehhlifae.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <matthew.garrett@nebula.com> writes:

> This set covers regressions and two obvious bugfixes. The rest can wait 
> for 3.9.

Hello Matthew,

may I request that you include the patch

      sony-laptop: fully enable SNY controlled modems

for 3.8 as well?  I'd even like it to go to stable if you and Mattia
agree.

My rationale is:

Making the driver set the same 3 bits which Windows set is obviously a
bug fix and not a new feature.  The fix is a simple oneliner, and is
required for a number of "newer" laptops, where newer in this case
includes most of 2012.  Without this fix rfkill will fail silently,
causing the wwan module to appear to be available but not working
because the radio is disabled.  This causes very hard to debug problems
for end users and distributions. Ref the bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=47751

See also the thread at http://ubuntuforums.org/showthread.php?t=2040205
for an example of the problems this bug causes for end users.


Thanks,
Bjørn
