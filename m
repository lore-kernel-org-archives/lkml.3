Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3C3XY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 19:24:26 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:40005 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab3C3XYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 19:24:25 -0400
Date: Sat, 30 Mar 2013 16:13:46 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Hongbo Zhang <hongbo.zhang@linaro.org>
Cc: linux@roeck-us.net, khali@linux-fr.org, lm-sensors@lm-sensors.org,
        dwmw2@infradead.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@linaro.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/5] Add ST-Ericsson AB8500 HWMON driver
Message-ID: <20130330231345.GA28021@lizard>
References: <1364368412-12810-1-git-send-email-hongbo.zhang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1364368412-12810-1-git-send-email-hongbo.zhang@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hongbo,

On Wed, Mar 27, 2013 at 03:13:27PM +0800, Hongbo Zhang wrote:
[...]
> Hongbo Zhang (5):
>   ab8500_btemp: make ab8500_btemp_get* interfaces public
>   ab8500: power: eliminate CamelCase warning of some variables
>   ab8500: power: add const attributes to some data arrays
>   ab8500: power: export abx500_res_to_temp tables for hwmon
>   hwmon: add ST-Ericsson ABX500 hwmon driver
> 
>  Documentation/hwmon/ab8500           |  22 ++
>  Documentation/hwmon/abx500           |  28 ++
>  drivers/hwmon/Kconfig                |  13 +
>  drivers/hwmon/Makefile               |   1 +
>  drivers/hwmon/ab8500.c               | 206 +++++++++++++++
>  drivers/hwmon/abx500.c               | 491 +++++++++++++++++++++++++++++++++++
>  drivers/hwmon/abx500.h               |  69 +++++
>  drivers/power/ab8500_bmdata.c        |  42 +--
>  drivers/power/ab8500_btemp.c         |   5 +-
>  drivers/power/ab8500_fg.c            |   4 +-
>  include/linux/mfd/abx500.h           |   6 +-
>  include/linux/mfd/abx500/ab8500-bm.h |   5 +
>  include/linux/power/ab8500.h         |  16 ++
>  13 files changed, 885 insertions(+), 23 deletions(-)

The patches look good to me, but I wonder how would you like to proceed
with them? The thing is, it touches ab8500 code quite a lot, and since
battery-2.6 tree already has a lot of ab8500 changes, your patches
conflict quite badly.

Personally, I would like to take them all via battery-2.6.git tree to
avoid the conflicts, but for this I will need you to rebase the patches
onto it.

Thanks!

Anton

p.s. I couldn't apply the patches neither on v3.8, nor v3.9-rc4 nor on my
current battery-2.6.git tree... :-/
