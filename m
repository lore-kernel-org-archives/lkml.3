Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbaEEX36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:29:58 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:46416 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaEEX35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:29:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAPz6YkXsig6XornqoMyn5DtRd9NECyc+qgQo39RQK0sDeat34Q@mail.gmail.com>
References: <CAPz6YkXsig6XornqoMyn5DtRd9NECyc+qgQo39RQK0sDeat34Q@mail.gmail.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Mon, 5 May 2014 16:29:36 -0700
X-Google-Sender-Auth: WXS-Wanvm3nGFOhqlh2lQBNdJA0
Message-ID: <CAPz6YkV2E2NBY9E8x4JJh2S-3oqdtk2yD=aNSOopYakcc2noLQ@mail.gmail.com>
Subject: Re: CPU performance counters not working on big.LITTLE switcher
To: linux-arm-kernel@lists.infradead.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>, Olof <olofj@chromium.org>,
        Stephane Eranian <eranian@google.com>,
        Bhaskar Janakiraman <bjanakiraman@chromium.org>,
        nicolas.pitre@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[sorry for HTML spam, resending]

Hi, we have the problem today that cpu based performance counters don't work
when we're using the big.LITTLE switcher on Exynos 5420, and it doesn't look
like code exists to deal with this in the switcher.

As it stands right now, if you put an A-15 or A-7 PMU node into your
device-tree on an bl_switcher system it's very broken.  At the minimum, I
think it should disable performance counters until there's some kind of
proper implementation.

I looked into trying to make this work, but it turned out to not be as
simple as just context switching counters from A-15 to A-7.  The biggest
problem is that the PMUs are not architecturally compatible.  There are
different events and differing numbers of counters on these two cores.
There's also the tangential issue of representing this in the device tree,
but that's far less important.

My guess as to how to fix this is to create an "architectural" PMU which
contains the intersection of the two performance monitor units with the
minimum number of counters supported by either core (which in this case
looks to be 4 on the A7).  However, I don't really have the bandwidth to
work on this at  the moment.  I was mostly wondering, have other people run
into this limitation and is there any sort of plan to work on it?
