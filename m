Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935625Ab3DHTVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:21:35 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:56543 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763199Ab3DHTVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:21:34 -0400
MIME-Version: 1.0
In-Reply-To: <51630C7C.9040003@gmail.com>
References: <1365439879-3398-1-git-send-email-dianders@chromium.org>
	<51630B26.1000102@samsung.com>
	<CAD=FV=Ui2C49Z=39qboo9CdETrea2z+_+Wc77pjfDWX26XtxJg@mail.gmail.com>
	<51630C7C.9040003@gmail.com>
Date: Mon, 8 Apr 2013 12:21:32 -0700
X-Google-Sender-Auth: B4x_4MyqFeRhR0ayV7u83RzysFc
Message-ID: <CAD=FV=UcKTBjKtyQFY4odTpBDKbNQEAHjyahqgNCsD570zq=pw@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: fix bad merge of display timing node to exynos5250-smdk5250.dts
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rahul Sharma <rahul.sharma@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin,

On Mon, Apr 8, 2013 at 11:29 AM, Kukjin Kim <kgene.kim@gmail.com> wrote:
> BTW, if any problems on current for-next, please kindly let me know.

I usually try to check linux-next at least once a week, but sometimes
it's more or less often.  At the moment I'm trying to track something
weird down but it seems like it has some userspace component to it.
I'll post a separate thread if I find a kernel problem there.

Aside from the RTC, my biggest problem right now is that reboot
stopped working at the same time as the common clock.  The
exynos5_restart() function is essentially behaving as a no-op since
the clock to the IP block that handles reset has been gated.  :(  The
bit "CLK_PMU_APBIF" is gated in "CLK_GATE_IP_PERIS". This used to be
ungated in exynos5_clk_ip_peris_ctrl().

I'm happy to test a patch that fixes this but I haven't yet had time
to try to fix it cleanly myself.


-Doug
