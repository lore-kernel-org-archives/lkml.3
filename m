Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935722Ab3DHT1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:27:14 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60453 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935690Ab3DHT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:27:12 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Doug Anderson <dianders@chromium.org>, Kukjin Kim <kgene.kim@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: [PATCH] ARM: dts: fix bad merge of display timing node to exynos5250-smdk5250.dts
Date: Mon, 08 Apr 2013 21:27:14 +0200
Message-ID: <2824266.emLkgITIHc@flatron>
User-Agent: KMail/4.10.2 (Linux/3.8.6-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CAD=FV=UcKTBjKtyQFY4odTpBDKbNQEAHjyahqgNCsD570zq=pw@mail.gmail.com>
References: <1365439879-3398-1-git-send-email-dianders@chromium.org> <51630C7C.9040003@gmail.com> <CAD=FV=UcKTBjKtyQFY4odTpBDKbNQEAHjyahqgNCsD570zq=pw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Monday 08 of April 2013 12:21:32 Doug Anderson wrote:
> Kukjin,
> 
> On Mon, Apr 8, 2013 at 11:29 AM, Kukjin Kim <kgene.kim@gmail.com> wrote:
> > BTW, if any problems on current for-next, please kindly let me know.
> 
> I usually try to check linux-next at least once a week, but sometimes
> it's more or less often.  At the moment I'm trying to track something
> weird down but it seems like it has some userspace component to it.
> I'll post a separate thread if I find a kernel problem there.
> 
> Aside from the RTC, my biggest problem right now is that reboot
> stopped working at the same time as the common clock.  The
> exynos5_restart() function is essentially behaving as a no-op since
> the clock to the IP block that handles reset has been gated.  :(  The
> bit "CLK_PMU_APBIF" is gated in "CLK_GATE_IP_PERIS". This used to be
> ungated in exynos5_clk_ip_peris_ctrl().
> 
> I'm happy to test a patch that fixes this but I haven't yet had time
> to try to fix it cleanly myself.

Common Clock Framework by default automatically gates unused clocks, just 
like regulator core does with unused regulators. Maybe this is the cause?

There is a CLK_IGNORE_UNUSED flag which disables this behavior for all 
clocks which have it set. Maybe it should be set for the problematic 
clock?

Best regards,
Tomasz

