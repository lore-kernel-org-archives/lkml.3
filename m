Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab3FCSnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:43:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62888 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3FCSnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:43:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] serial: omap: repair building without PM_SLEEP
Date: Mon, 3 Jun 2013 20:43:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sourav Poddar <sourav.poddar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Felipe Balbi <balbi@ti.com>
References: <1844339.mxci2DdvBF@wuerfel> <20130603170730.GA30767@kroah.com>
In-Reply-To: <20130603170730.GA30767@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306032043.38656.arnd@arndb.de>
X-Provags-ID: V02:K0:+FD3Cg7baMwgQw4luKP30s+77f1HLE9ZLa4uhNi/fmI
 bfXPMxl+q8Oe1IxMMzwEYC319KQydp6eeaCOW/QStvvzSjs0ts
 Es4MUUpuQAaDqi4wAObwKPAdHoOth7V1J6XYJ8HaQxjoWsL/o+
 S38KXkCCElhbvEDpMq1fb0PTK5OIcjKvqN/zCkRCvTpPg5zT0b
 p5Ehx3+3IgX4N5AAHM1oRY1UMmUeWxiUniwuqQCt6kTsgucEd3
 ecT5JaXq1geMTNBcULIhC28aeEH9RfMc02whNmQAO+XGjmhA4B
 Tiq5suxTca323vU1odTTtiHnhT35I4c2uyfUi+Jdwzagr/PNA8
 8n/Y0YuI/dagkzj2wfpo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 June 2013, Greg Kroah-Hartman wrote:
> On Sat, Jun 01, 2013 at 11:18:13AM +0200, Arnd Bergmann wrote:
> > A recent bug fix in 3.10, ddd85e225c "serial: omap: prevent runtime PM for
> > "no_console_suspend"", introduced a regression from an obvious typo:
> 
> I don't see that commit id, or commit, in Linus's tree at all.  Where do
> you see it?
> 
> > drivers/tty/serial/omap-serial.c:1677:14: error: 'serial_omap_complete' 
> >       undeclared here (not in a function)
> > 
> > This changes the incorrectly added macro to the one that we need instead.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > Please apply for 3.10-rc
> 
> Really?  It doesn't apply to 3.10-rc3 or -rc4 from what I can tell.

Sorry, my mistake. Since the bug was introduced as part of a bug fix
I assumed it was in 3.10-rc but did not look carefully. The problem
only exists in tty-next at the moment.

	Arnd
