Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3LNXD7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 18:03:59 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:34273 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab3LNXD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 18:03:57 -0500
Message-ID: <1387062231.13062.43.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 16/16] misc: support for I-8024 in LP-8x4x
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Date: Sun, 15 Dec 2013 03:03:51 +0400
In-Reply-To: <201312142159.40250.arnd@arndb.de>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <1386901645-28895-1-git-send-email-ynvich@gmail.com>
	 <1386901645-28895-17-git-send-email-ynvich@gmail.com>
	 <201312142159.40250.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-14 at 21:59 +0100, Arnd Bergmann wrote:
> Have you checked that the nsleep definition actually does the
> right thing here? 450 nanoseconds must be close the latency
> you get from calling schedule_hrtimeout(). I'd suggest using
> either ndelay() or usleep_range() instead, depending on your
> needs.

Documentation/timers/timers-howto.txt stated there was a significant
overhead when setting up usleep_range. I studied implementation and
found that schedule_hrtimeout was certainly less than 520000 CPU cycles
that udelay(1) would consume.

It worked. I haven't checked actual delay time. However, machines with
the driver (based on 3.8) are in production since May 2013 without
issues.

> If nsleep is really useful here, we should probably add that
> as a generic API rather than having it in one driver.

I've also used this nsleep for driving RTC clock (DS1302) since May
2013.

Now I see that my code is a clone of usleep_range(x, x). I will convert
my code to use it.


