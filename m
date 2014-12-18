Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaLRKfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:35:47 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52328 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaLRKfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:35:45 -0500
Message-ID: <5492ADFC.1060006@redhat.com>
Date: Thu, 18 Dec 2014 11:35:40 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>, Kevin Cernekee <cernekee@gmail.com>
CC: tglx@linutronix.de, bp@alien8.de, gnomes@lxorguk.ukuu.org.uk,
        computersforpeace@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/4] Stop maintainer abuse
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com> <20141216130939.166c4369@lwn.net>
In-Reply-To: <20141216130939.166c4369@lwn.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 16/12/2014 19:09, Jonathan Corbet wrote:
> In general, I worry about trying to codify things too much just because
> different maintainers have different expectations.  As Linus noted, some
> maintainers have their work done by the time the merge window starts and
> can take patches just fine — until something catches fire, at least.

As one of the recipients of the original evidence ("[v3 00/26] Add VT-d
Posted-Interrupts support"), I can only agree.

The timing of the series wasn't optimal for me, either: I do _not_ take
patches during the merge window and generally would like people that are
not KVM submaintainers to leave me alone.

On the other hand, the series is complex and spans four maintainers
(KVM, VFIO, IOMMU, x86), and it would be weird to blame people for
posting early.  In this case the x86 parts are just one patch out of 26.
 When x86 maintainers see something like this, they can expect the KVM
maintainer (me) to tell them "can you review the approach" or just "can
you give your Acked-by" once the rest of the series is mature.

As an example of a different workflow, generally things go like this for me:

   window   Put up fires, otherwise do non-kernel stuff

   rc1-rc2  Test large features, gather small patches in a rebased queue

   rc2-rc3  Big testing week: open next tree

   rc3-rc6  Merge small features

   rc6-     Merge bugfixes only, do non-kernel stuff, start bugging
            submaintainers

So for me the worst time to send patches is actually the week between
rc2 and rc3.  You're pretty much guaranteed to be ignored at that time,
unless of course the patch is for current mainline.

If you send during the merge window, chances are I'll be busy doing
something else and I won't have a fast turnaround.  But a mail from your
manager asking to merge a large feature after rc6 will definitely make
me more grumpy.

Paolo
