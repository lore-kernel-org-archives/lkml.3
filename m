Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3KOPgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:36:20 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:38277 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3KOPgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:36:12 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19vLi09LJ0aYg+IBZFVvdEb
Date: Fri, 15 Nov 2013 07:36:08 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] ARM: OMAP4460: cpuidle: Extend
 PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD on cpuidle
Message-ID: <20131115153608.GX10317@atomide.com>
References: <1382467484-16957-1-git-send-email-grygorii.strashko@ti.com>
 <5266CCE3.1090801@ti.com>
 <20131114183535.GL10317@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114183535.GL10317@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [131114 10:36]:
> * Grygorii Strashko <grygorii.strashko@ti.com> [131022 12:09]:
> > The same workaround as ff999b8a0983ee15668394ed49e38d3568fc6859
> > "ARM: OMAP4460: Workaround for ROM bug because of CA9 r2pX GIC ..."
> > need to be applied not only when system is booting, but when MPUSS hits
> > OSWR state through CPUIdle too. Without this WA the same issue is
> > reproduced now on boards PandaES and Tablet/Blaze with SOM OMAP4460
> > when CONFIG_CPU_IDLE is enabled.
> > After MPUSS has enterred OSWR and waken up:
> > - GIC distributor became disabled forever
> > - scheduling is not performed any more
> > 
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Reported-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Applying into omap-for-v3.13/fixes thanks.

Hmm looks like this breaks the build with randconfigs at least
with the attached .config, so dropping for now.

arch/arm/mach-omap2/built-in.o: In function `omap_enter_idle_coupled':
:(.text+0xb48c): undefined reference to `pm44xx_errata'

Can you please check and repost?

Thanks,

Tony


