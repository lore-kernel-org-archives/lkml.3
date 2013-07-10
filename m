Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab3GJU1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:27:33 -0400
Received: from 1wt.eu ([62.212.114.60]:34517 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391Ab3GJU1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:27:32 -0400
Date: Wed, 10 Jul 2013 22:27:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Rich, Jason" <jason.rich@tekcomms.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Panic at _blk_run_queue on 2.6.32
Message-ID: <20130710202729.GA18877@1wt.eu>
References: <636295BFF4A001418A00F46569A2CD2B161CE88B@US-PLNO-EXM01-P.global.tektronix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <636295BFF4A001418A00F46569A2CD2B161CE88B@US-PLNO-EXM01-P.global.tektronix.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Tue, Jul 09, 2013 at 05:42:29PM +0000, Rich, Jason wrote:
> Greetings,
> I've recently encountered an issue where multiple hosts are failing to boot up about 1/5 of the time.  So far I have confirmed this
> issue on three seperate host machines.  The issue presents itself after updating 2.6.32.39 to patch 50 and patch 61.
> Both patch levels result in the failure described below.  Since this occurs on multiple hosts, I feel I can safely rule out hardware.

First, thank you for your very detailed report. Do you think you could narrow
this down to a specific kernel version ? Given that there are exactly 10
versions between .39 and .50, I think that a version-level bisect would take
3 or 4 builds (so probably around 20 reboots).

It would help us spot the faulty patch. Right now, there are 546 patches
between .39 and .50 so it's quite hard to find the culprit, even with your
full trace. That does not mean we'll immediately spot it, maybe a deeper
bisect will be needed, but it should be easier.

> It is also of note that I have not seen this behavior on the 3.4.26 kernel, or on any of my 32bit hosts.  

This is a good news, because we're probably missing one fix from a more
recent version that addressed a similar regression and that we might
backport into 2.6.32.62.

> That said, I have to support this software release (which runs on the 2.6 kernel) for at least another two years.  

Be careful on this point, 2.6.32 is planned for EOL next year :

   https://www.kernel.org/category/releases.html

You might want to consider migrating to a supported distro kernel or
to 3.2 instead. That said, if you follow carefully the updates from
later kernels, you might prefer to maintain your own backports of
the patches that are relevant to your usage.

Best regards,
Willy

