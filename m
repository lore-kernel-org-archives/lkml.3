Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaHYDNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 23:13:44 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:62323 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbaHYDNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 23:13:43 -0400
MIME-Version: 1.0
In-Reply-To: <53FAA544.4030401@intel.com>
References: <53F9CC77.70009@t-online.de>
	<CA+55aFwZP1gyf=mvTrKjWwj6YE6=5y1+aZdmsNMHUp6d3dckXw@mail.gmail.com>
	<53FAA544.4030401@intel.com>
Date: Sun, 24 Aug 2014 20:13:42 -0700
X-Google-Sender-Auth: 4L26qroq1D_j9HJEsGMGv0COdFA
Message-ID: <CA+55aFzaHF=S3QQ6M-+JBdWVRCSHKs-jjKo==8OS7q90cUyHBw@mail.gmail.com>
Subject: Re: [Bug 3.14.17] inconsistent lock state
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Knut Petersen <Knut_Petersen@t-online.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 7:53 PM, Lan Tianyu <tianyu.lan@intel.com> wrote:
>
> Sorry about this. We are resolving the issue in the other bug
> report(https://lkml.org/lkml/2014/8/21/606) and I have proposed a fix
> patch(http://marc.info/?l=linux-acpi&m=140869309231199&w=2).

Ahh. Good. That patch looks fine to me, and while it makes me worry a
bit that some codepath expects the power/sleep button to be handled
immediately in interrupt context, I guess the actual callbacks have
never actually done anything but schedule other things to happen (ie
add events to some queue), and making the context be the same as the
other notify callbacks would seem to be a good thing regardless of
this particular bug.

Knut - can you please test the patch Lan pointed at? I realize it
doesn't seem to be entirely consistent for you (which is a bit
surprising, I wonder why lockdep doesn't trigger it consistently), but
it would be good to have more testing. Even if that patch looks
"obviously good" (tm) at a quick glance.

                  Linus
