Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3HDOUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:20:00 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:42013 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3HDOT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:19:58 -0400
MIME-Version: 1.0
In-Reply-To: <1861338.WxIinvfTH6@vostro.rjw.lan>
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com>
	<51FDABFD.3070601@gmail.com>
	<CAMP44s0+VKH_vTRiXvhKz8gGUwAa+_Hgf_dN3UddYE1Z7DLPAA@mail.gmail.com>
	<1861338.WxIinvfTH6@vostro.rjw.lan>
Date: Sun, 4 Aug 2013 09:19:56 -0500
Message-ID: <CAMP44s0EwO11to-nfjhKkUidQKe6h=y0o-V7gYmF_mJeKhMRtQ@mail.gmail.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 4, 2013 at 9:19 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, August 04, 2013 01:42:49 AM Felipe Contreras wrote:

>> Personally I think there are better ways to fix the code for the
>> synthetic case than what you patch does, which will also make _BQC
>> work. That can be discussed later though, the one-liner is simple, and
>> it works.
>
> So, let's assume that the one-liner goes into 3.11 and work further with that
> assumption.
>
> How would you address the sythetic case (on top of the one-liner)?

I would write and read two values instead of one. The code is trying
to check if _BQC is always returning the maximum, and if you try with
two values you can be absolutely certain if that's happening or not;
it doesn't even matter which values you choose. Even in the synthetic
case that only has two values the check would work correctly and
detect that _BQC works correctly (or not).

In my machine I think the issue is slightly different, I think _BCM is
failing, at least until enabling the _DOS thing, but at the end of the
day it's the same thing for the check; _BQC is always returning the
same value, and the code above will find that out, regardless of which
values are tested.

For my particular machine though, I think it's more interesting to
find out why _BCM is failing before _DOS, and why efaa14c made it
work. If that is actually the case.

-- 
Felipe Contreras
