Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3EaMs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:48:58 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:38052 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321Ab3EaMsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:48:51 -0400
To: Sergey Yanovich <ynvich@gmail.com>
Subject: Re: [PATCH] rtc-ds1302: handle write protection
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 May 2013 14:48:46 +0200
From: Marc Zyngier <maz@misterjones.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
Organization: Metropolis
In-Reply-To: <1369929888.16480.5.camel@host5.omatika.ru>
References: <1369092090-5384-1-git-send-email-ynvich@gmail.com> <20130529155311.9e35e847968f3923bc83f4cd@linux-foundation.org> <1369908882.17429.13.camel@host5.omatika.ru> <53f44a9ec4c8391288d6c132fd5689da@localhost> <1369929888.16480.5.camel@host5.omatika.ru>
Message-ID: <76d55c94295049f87bc4f3dea64ebbb1@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: ynvich@gmail.com, akpm@linux-foundation.org, rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org, a.zummo@towertech.it, sachin.kamat@linaro.org, jg1.han@samsung.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013 20:04:48 +0400, Sergey Yanovich <ynvich@gmail.com>
wrote:
> From f1cd048a066b249082752a96abce7d33a0cd4ea3 Mon Sep 17 00:00:00 2001
> From: Sergey Yanovich <ynvich@gmail.com>
> Date: Tue, 21 May 2013 03:06:31 +0400
> Subject: [PATCH] rtc-ds1302: handle write protection
> 
> This chip has a control register and can prevent altering saved clock.
> Without this patch we could have:
> ----8<----
> (arm)root@pac14:~# date
> Tue May 21 03:08:27 MSK 2013
> (arm)root@pac14:~# /etc/init.d/hwclock.sh show
> Tue May 21 11:13:58 2013  -0.067322 seconds
> (arm)root@pac14:~# /etc/init.d/hwclock.sh stop
> [info] Saving the system clock.
> [info] Hardware Clock updated to Tue May 21 03:09:01 MSK 2013.
> (arm)root@pac14:~# /etc/init.d/hwclock.sh show
> Tue May 21 11:14:15 2013  -0.624272 seconds
> ----8<----
> 
> The patch enables write access to rtc before the driver tries to write
time
> and re-disables when time data is written.
> 
> Signed-off-by: Sergey Yanovich <ynvich@gmail.com>

FWIW,

Acked-by: Marc Zyngier <maz@misterjones.org>

        M.
-- 
Who you jivin' with that Cosmik Debris?
