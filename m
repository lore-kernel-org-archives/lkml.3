Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab3LaFHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 00:07:19 -0500
Received: from blu0-omc4-s24.blu0.hotmail.com ([65.55.111.163]:46880 "EHLO
	blu0-omc4-s24.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab3LaFHQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 00:07:16 -0500
X-TMN: [ZDI4Q6bjh/0XmuagaiuQ/lcfF4QzYhYH]
X-Originating-Email: [lgxue@hotmail.com]
Message-ID: <BLU172-W18A7B97F4E688F416C5DABACC90@phx.gbl>
From: Joe Xue <lgxue@hotmail.com>
To: Pavel Machek <pavel@ucw.cz>
CC: "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH] Add LED pattern trigger
Date: Tue, 31 Dec 2013 00:00:39 -0500
Importance: Normal
In-Reply-To: <20131230183302.GA28430@amd.pavel.ucw.cz>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>,<20131230183302.GA28430@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 31 Dec 2013 05:00:39.0870 (UTC) FILETIME=[4022B5E0:01CF05E5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What about something like this?
>
> Not shcheduling timer when nothing changed should save a bit of power/cpu...
>
> if (pattern_data->pattern[pattern_data->count] == '/') {
> return;
> }
>
> this = pattern_data->pattern[pattern_data->count]
> if (this == '#')
> new_brigtness = pattern_data->brightness_on;
> if (this == ' ')
> new_brigtness = LED_OFF;
> repeat = 1;
> while (pattern_data->pattern[pattern_data->count + repeat] == this)
> repeat++;
>
> mod_timer(&pattern_data->timer,
> jiffies + msecs_to_jiffies(pattern_data->delay_unit * repeat));
>
>
Working on it.

Thanks for your help.

Joe 		 	   		  