Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaKTLs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:48:56 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:60614 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaKTLsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:48:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        linaro-kernel@lists.linaro.org, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, patches@linaro.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC PATCH] arm: imx: Workaround i.MX6 PMU interrupts muxed to one SPI
Date: Thu, 20 Nov 2014 12:48 +0100
Message-ID: <3404793.vJmOz13jz0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416483757-24165-1-git-send-email-daniel.thompson@linaro.org>
References: <1416483757-24165-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:T3FVIlYSTGEaSmCsaWrRStTZwEF35MBoIaIkmA/i9u9
 ELmc0dSAN6LWV1y1apKHwlffyxXw1FGfs+32L8gyxcNHidQ7m+
 GZ6JgaX8+QDRYL9gzXa9mkQrC2EqVXwXRG2oSaY29LvSYOFsOF
 U1Filcjwj8XSjctpbI5uxTi/PwBLoxFEjh5zJ+RvKhPFfajS/r
 TjjKrb4Ppc5lOkbHZozbydIYOeLAOx9flCq3S6TgrxqJuW8fm2
 SWjNuVcxl8sqPTPWdpa0fELJ5sy4s4mYogpgfO7iD0q02eJf+j
 zPiqFln6Kzj/MRrH1oqFlKnnEwjK56NYRJYIx7gQ/+/bPI0sFS
 bmw5UBAXLMtv+Q3q1aOA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2014 11:42:37 Daniel Thompson wrote:
> Notes:
>     This patch adopts the approach used on the u8500 (db8500_pmu_handler)
>     but the logic has been generalized for any number of CPUs, mostly
>     because the i.MX6 has a both dual and quad core variants.
>     
>     However it might be better to include the generalized logic in the main
>     armpmu code. I think the logic could be deployed automatically on SMP
>     systems with only a single not-percpu IRQ, replacing the
>     plat->handle_irq dance we currently do to hook up this code.
>     
>     Thoughts? (or is there already shared logic to do this that I
>     overlooked)
> 

I would definitely prefer to have this handled in the armpmu implementation,
given that there are at least two platforms that need the exact same
hack.

	Arnd
