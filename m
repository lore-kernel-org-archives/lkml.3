Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbbAENxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:53:06 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:38057 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbbAENxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:53:05 -0500
Date: Mon, 5 Jan 2015 14:52:59 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH] next: microblaze: Fix build failure
Message-ID: <20150105135259.GB8156@localhost.localdomain>
References: <1420296800-17045-1-git-send-email-linux@roeck-us.net>
 <20150103170118.GA8958@localhost.localdomain>
 <20150105085212.GA11117@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105085212.GA11117@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 12:52:12AM -0800, Guenter Roeck wrote:
> On Sat, Jan 03, 2015 at 06:01:18PM +0100, Richard Cochran wrote:
> > On Sat, Jan 03, 2015 at 06:53:20AM -0800, Guenter Roeck wrote:
> > > Microblaze build in linux-next fails with
> > > 
> > > arch/microblaze/kernel/timer.c:224:2: error:
> > > 	implicit declaration of function 'timecounter_init'
> > > 
> > > Caused by missing include file in microblaze timer code.
> > 
> > Already fixed in net-next.
> > 
> The arm64 build is still broken in next-20150105 due to the same commit.

Do you mean drivers/clocksource/arm_arch_timer.c?

> Did you fix that already as well ?

Nope. It probably needs just one line:

+ #include <linux/timecounter.h>

Can you please test build that for me?

Thanks,
Richard
