Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3HENx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:53:58 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56576 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab3HENxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:53:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
Date: Mon, 05 Aug 2013 16:04:11 +0200
Message-ID: <23723258.099Re4s3PJ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAMP44s0EwO11to-nfjhKkUidQKe6h=y0o-V7gYmF_mJeKhMRtQ@mail.gmail.com>
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com> <1861338.WxIinvfTH6@vostro.rjw.lan> <CAMP44s0EwO11to-nfjhKkUidQKe6h=y0o-V7gYmF_mJeKhMRtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 04, 2013 09:19:56 AM Felipe Contreras wrote:
> On Sun, Aug 4, 2013 at 9:19 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, August 04, 2013 01:42:49 AM Felipe Contreras wrote:
> 
> >> Personally I think there are better ways to fix the code for the
> >> synthetic case than what you patch does, which will also make _BQC
> >> work. That can be discussed later though, the one-liner is simple, and
> >> it works.
> >
> > So, let's assume that the one-liner goes into 3.11 and work further with that
> > assumption.
> >
> > How would you address the sythetic case (on top of the one-liner)?
> 
> I would write and read two values instead of one. The code is trying
> to check if _BQC is always returning the maximum, and if you try with
> two values you can be absolutely certain if that's happening or not;
> it doesn't even matter which values you choose. Even in the synthetic
> case that only has two values the check would work correctly and
> detect that _BQC works correctly (or not).

I like that.

> In my machine I think the issue is slightly different, I think _BCM is
> failing, at least until enabling the _DOS thing, but at the end of the
> day it's the same thing for the check; _BQC is always returning the
> same value, and the code above will find that out, regardless of which
> values are tested.
> 
> For my particular machine though, I think it's more interesting to
> find out why _BCM is failing before _DOS, and why efaa14c made it
> work. If that is actually the case.

That depends on how the BIOS+platform is designed and that may change from
one system to another quite a bit.

The only common denominator is what Windows expects (and that unfortunately
depends on the version of Windows too), because that's the functionality
which is likely to have been tested.  Anything else is likely to be untested
and therefore most probably buggy.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
