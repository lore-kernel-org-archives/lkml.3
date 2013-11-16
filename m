Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab3KPHDU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 02:03:20 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36817 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3KPHDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 02:03:17 -0500
Date: Sat, 16 Nov 2013 08:03:05 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Miroslav Lichvar <mlichvar@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
Message-ID: <20131116070304.GB4355@netboy>
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 03:50:40PM +0100, Miroslav Lichvar wrote:

>  include/linux/timekeeper_internal.h |   4 +
>  kernel/time/timekeeping.c           | 209 +++++-------------------------------
>  2 files changed, 31 insertions(+), 182 deletions(-)

This looks like an impressive simplification...

> -	 * So the following can be confusing.

Yep.

So I really have no idea how the deleted code worked (or didn't work
for nohz), but I can confirm that nohz time keeping is broken under
light system load. Running a high load (like recompiling the kernel on
all cores for CONFIG_HZ_PERIODIC=y ;) hides the issue, but that is
obviously not the right solution.

Out of my ignorance, two questions spring to mind.

1. Considering the simplicity of Miroslav's patch, what was the
   benefit of the much more complicated code in the first place?

2. Does this patch work in the CONFIG_HZ_PERIODIC case just as well as
   the deleted code?

Thanks,
Richard
