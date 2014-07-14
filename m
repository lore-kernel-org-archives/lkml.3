Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbaGNPIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:08:23 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:57569 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755947AbaGNPIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:08:02 -0400
Date: Mon, 14 Jul 2014 16:07:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/7] arm64: Support restart through restart notifier
 call chain
Message-ID: <20140714150733.GE1112@arm.com>
References: <1405265431-4561-1-git-send-email-linux@roeck-us.net>
 <1405265431-4561-3-git-send-email-linux@roeck-us.net>
 <20140714145504.GD1112@arm.com>
 <53C3F0BA.5020201@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C3F0BA.5020201@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 04:01:14PM +0100, Guenter Roeck wrote:
> On 07/14/2014 07:55 AM, Catalin Marinas wrote:
> > On Sun, Jul 13, 2014 at 04:30:26PM +0100, Guenter Roeck wrote:
> >> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> >> index 43b7c34..b2da6d5 100644
> >> --- a/arch/arm64/kernel/process.c
> >> +++ b/arch/arm64/kernel/process.c
> >> @@ -174,6 +174,8 @@ void machine_restart(char *cmd)
> >>   	/* Now call the architecture specific reboot code. */
> >>   	if (arm_pm_restart)
> >>   		arm_pm_restart(reboot_mode, cmd);
> >> +	else
> >> +		kernel_restart_notify(cmd);
> >
> > There are couple of drivers specific to arm64, once they are converted
> > we can get rid of arm_pm_restart entirely here.
> 
> I thought you wanted to keep exporting arm_pm_restart.

No, I just thought you don't want the restart mechanism implemented in
modules but the notifier registration still allows that, so I didn't
fully get the reasoning. But I agree on the race aspect.

> That logically implies
> that you want to have the ability to write new drivers which use it, which
> in turn implies that converting existing drivers would not make much sense.

If the new handler registration mechanism gives the functionality, I
don't see why we should keep arm_pm_restart around (for arm64 it's
easier since there aren't many drivers setting it).

-- 
Catalin
