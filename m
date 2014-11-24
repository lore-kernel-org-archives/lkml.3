Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbaKXUPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:15:45 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:49996 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbaKXUPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:15:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] Add "Simple" / Renesas Bus State Controller Driver
Date: Mon, 24 Nov 2014 21:15:33 +0100
Message-ID: <6261300.I132f1jLqB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416859808-18503-1-git-send-email-geert+renesas@glider.be>
References: <1416859808-18503-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:sZ1hRAK2tE42ww355P4iSpKAOlZQL6rnq5t7B7lgl1m
 RiQvaZLzFcvhIlEkt4IUYYrYZTZ65izlPXpOAAqrIPqjtzSP1T
 /nJKylv9sEroSq0XxycPFixB9z+1V951Y6yWp9prmqpuJ6MgX/
 rI4O0Z5q80xoOBE7TV2JKF9m0zGheZDYt8U71uQmY8J7J0dgQ8
 VLEDcSOpkdpqjVFUPONr3rjP3d+9MhRq0gRxGYtojqDVw3TmLy
 5Tuai+KLEqY5ZhOIlLTUZot0g9v6OvaWmc10YzV91zN28oE7TJ
 5AfTExBoZ8ztlkrHgB5KbZIOn8Ih1qdTRIsd2eOflEMKjh/n9M
 VYn7J4LTz7GnWJz9SU98=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 November 2014 21:10:05 Geert Uytterhoeven wrote:
> As this minimal BSC driver isn't hardware-specific at all, I'm wondering
> if there's a simpler way to do this?
>   - Should the driver be renamed to "simple-bus", and match "simple-bus"?
>   - Should this be moved to core code, without an explicit driver for
>     "simple-bus"? I.e. should the driver core just enable runtime PM for
>     all devices not bound to a driver, as they may represent buses with
>     child devices that do rely on runtime PM?
> 
> Thanks for your comments and suggestions!

My understanding of simple-bus is that it's something that does
not have any power-management capabilities, and I'd rather not
add clocks or interrupts to it.

What I think makes more sense is to have a bus driver for it
in drivers/bus, remove the "simple-bus" compatibility value
and have the driver take care of registering the power domain
and probing the child devices using of_platform_populate on
itself.

	Arnd
