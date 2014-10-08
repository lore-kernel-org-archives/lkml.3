Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaJHSvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:51:49 -0400
Received: from mout.gmx.net ([212.227.17.20]:59048 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbaJHSvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:51:47 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Guenter Roeck <linux@roeck-us.net>, devel@driverdev.osuosl.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, Andrey Danin <danindrey@mail.ru>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 29/44] staging: nvec: Register with kernel poweroff handler
Date: Wed, 08 Oct 2014 20:51:10 +0200
Message-ID: <1986471.ednzxGGBeV@ax5200p>
User-Agent: KMail/4.13.3 (Linux/3.13.0-35-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1412659726-29957-30-git-send-email-linux@roeck-us.net>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net> <1412659726-29957-30-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:ZCF+iHlP1ZyF0fTaEaxJsUQXT8GBnkIPZCyrHbGguV8RZpFBRHN
 aja7Y8iOaYD+oXbEzTQsi+ZNFVMjdLvSJaD/eZ3GU1vYygVxvmqHY/1RRfImpgHCuS9C1bP
 tpica/ELVpgNpwIv5jkIs4KH1yisPClqZt0tfYdX5rjTu2vpZZSR7wwB3OOM8qU/9wjpy6/
 jG/A36VS1qnRSbsqS6qJw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 06 Oktober 2014, 22:28:31 schrieb Guenter Roeck:
> Register with kernel poweroff handler instead of setting pm_power_off
> directly. Register with default priority value of 128 since we don't know
> any better.

I just tested this change and it seems to break power off. What the driver 
does it to queue the power off request and execute it sometime later. The 
command is send via i2c to an embedded controller (mfd device) which is 
responsible for removing the power.

I haven't analyzed further, but I guess this could be related with the atomic 
discussion brought up in some other thread of this patch series.

Marc

