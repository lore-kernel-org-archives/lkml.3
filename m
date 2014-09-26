Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaIZFwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 01:52:36 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:43483 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbaIZFwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 01:52:35 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <5424FFF4.4010506@smartplayin.com>
Date: Fri, 26 Sep 2014 11:26:04 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Wim Van Sebroeck <wim@iguana.be>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: linux-next: build failure after merge of the watchdog tree
References: <20140926154031.4bc4dc39@canb.auug.org.au>
In-Reply-To: <20140926154031.4bc4dc39@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2014 11:10 AM, Stephen Rothwell wrote:
> Hi Wim,
> 
> After merging the watchdog tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
> 
> 
> drivers/watchdog/meson_wdt.c: In function 'meson_wdt_probe':
> drivers/watchdog/meson_wdt.c:178:2: error: implicit declaration of function 'register_restart_handler' [-Werror=implicit-function-declaration]
>   err = register_restart_handler(&meson_wdt->restart_handler);
>   ^
> drivers/watchdog/meson_wdt.c: In function 'meson_wdt_remove':
> drivers/watchdog/meson_wdt.c:193:2: error: implicit declaration of function 'unregister_restart_handler' [-Werror=implicit-function-declaration]
>   unregister_restart_handler(&meson_wdt->restart_handler);
>   ^
>
This is because Guenter Roeck's restart_notifier mechanism [1] has not
yet made it to linux-next.

Oh yes, I checked it now its already pulled in master branch of linux-next.

> Caused by commit 575f4153957b ("ARM: meson: add watchdog driver").
> 
> I have reverted that commit for today.
> 
[1]: https://patchwork.kernel.org/patch/4746721/

Thanks
Pramod
