Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3DWUVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:21:17 -0400
Received: from mout.gmx.net ([212.227.15.15]:49979 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab3DWUVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:21:16 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX18guNYoljYg7KXKFgYkrJ1zrujQ4Rs/lf+FyEX2lY
	WKYm9cv9EhIqRE
From: Marc Dietrich <marvin24@gmx.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/21] staging: nvec: allow modular build
Date: Tue, 23 Apr 2013 22:21:03 +0200
Message-ID: <11391915.IGaQsBJu0i@ax5200p>
User-Agent: KMail/4.8.5 (Linux/3.5.0-21-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <201304232214.18254.arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de> <1373204.GiWOFfjzyB@ax5200p> <201304232214.18254.arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013 22:14:18 Arnd Bergmann wrote:
> On Tuesday 23 April 2013, Marc Dietrich wrote:
> > It builds, but I haven't tried out it yet. At least the mfd children need
> > to unregister the event notifier I guess. Anyway, I have no time to test
> > this now, so I prefer to force =y for the dependencies for now.
> 
> Ah, so you can load it fine, but not safely unload it? In that case I think
> it's better to leave it as tristate but remove the module_exit() function to
> prevent unloading.
> 
> You'll have to change the module_platform_driver() back into a manual
> module_init() function to register the driver, but that sounds like
> the cleanest solution aside from fixing the notifier calls.

ok, I'll look into it - maybe I can also fix unloading.

Thanks!

Marc


