Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3H3Ljc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:39:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51229 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3H3Lja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:39:30 -0400
Date: Fri, 30 Aug 2013 12:39:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Pawel Moll <Pawel.Moll@arm.com>
Subject: Re: [PATCH RFC v2 14/16] ARM: vexpress: remove custom .init_time
	hook
Message-ID: <20130830113918.GV6617@n2100.arm.linux.org.uk>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377638890-371-15-git-send-email-sebastian.hesselbarth@gmail.com> <201308291535.53005.arnd@arndb.de> <521F901B.3090305@gmail.com> <1377856951.3655.34.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377856951.3655.34.camel@linaro1.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 11:02:31AM +0100, Jon Medhurst (Tixy) wrote:
> After adding of_clk_init(NULL) to time_init() things boot OK for me with
> this patch. However, do we know that sched_clock is never going to get
> read before time_init() has actually started the clock it reads? Are we
> making things more fragile?

As I've been saying for years, sched_clock gets read for the first time
in sched_init() -> init_idle() which occurs before time_init().

Whether that matters or not is debatable, but the first read should return
zero, and it will return zero after initialization - so I think all we end
up losing is some accounting of the time taken in the early kernel boot.

If we wish to talk about correctness, then arguably it isn't correct.
