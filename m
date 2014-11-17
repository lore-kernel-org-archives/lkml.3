Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaKQJRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:17:15 -0500
Received: from gloria.sntech.de ([95.129.55.99]:50304 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaKQJRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:17:14 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Loic Poulain <loic.poulain@intel.com>
Cc: Doug Anderson <dianders@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Chris Zhong <zyw@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Andrew Bresticker <abrestic@chromium.org>,
        mika.westerberg@linux.intel.com, heikki.krogerus@linux.intel.com,
        andriy.shevchenko@linux.intel.com, wens@csie.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250_dw: Handle no_console_suspend when uart loses state
Date: Mon, 17 Nov 2014 10:20:28 +0100
Message-ID: <4280750.Abh5aXOcW7@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <5469B828.90401@intel.com>
References: <1416011556-23422-1-git-send-email-dianders@chromium.org> <5469B828.90401@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 17. November 2014, 09:56:08 schrieb Loic Poulain:
> > In certain suspend modes on certain boards the 8250 UART may lose
> > state when the device goes to suspend.  If we're using
> > no_console_suspend this can cause lots of problems during resume.
> > 
> > Let's cache the basic UART config registers at suspend time and if we
> > notice that the UART loses state (by looking at a canary stored in the
> > scratch register) we'll restore it.
> 
> If I'm not wrong, it's already done in acpi_lpss suspend/resume (for
> 8250_dw).
> Commit c78b0830667a7e7c1f0ca65b76b33166a84806b3.

It looks like it, but of course only takes into account devices probed via 
acpi, missing the devices probed via devicetree.

So it looks like we need Doug's solution somehow, question would be if it 
should be excluded on acpi platforms.


Heiko
