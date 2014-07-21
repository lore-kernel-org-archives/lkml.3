Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbaGUMbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:31:33 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20732 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932096AbaGUMbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:31:31 -0400
Date: Mon, 21 Jul 2014 13:30:56 +0100
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
Subject: Re: [PATCH v5 0/7] kernel: Add support for restart handler call chain
Message-ID: <20140721123056.GF12817@arm.com>
References: <1405668856-13738-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405668856-13738-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 08:34:09AM +0100, Guenter Roeck wrote:
> Patch 1 of this series implements the restart handler function. Patches 2 and 3
> implement calling the restart handler chain from arm and arm64 restart code.
> 
> Patch 4 modifies the restart-poweroff driver to no longer call arm_pm_restart
> directly but machine_restart. This is done to avoid calling arm_pm_restart
> from more than one place. The change makes the driver architecture independent,
> so it would be possible to drop the arm dependency from its Kconfig entry.
> 
> Patch 5 and 6 convert existing restart handlers in the watchdog subsystem
> to use the restart handler. Patch 7 unexports arm_pm_restart to ensure
> that no one gets the idea to implement a restart handler as module.

For the current patches:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Do you plan to convert more of the power/drivers/reset/ code?

BTW, is it worth doing something similar for pm_power_off (there is
generic code calling it directly, so slightly more complicated than
pm_restart)?
