Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbbAEWzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:55:46 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:45066 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753031AbbAEWzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:55:44 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18kjyJ8E3TEHCvqofjMZBPF
Date: Mon, 5 Jan 2015 14:51:35 -0800
From: Tony Lindgren <tony@atomide.com>
To: Dave Gerlach <d-gerlach@ti.com>
Cc: balbi@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, Benoit Cousson <bcousson@baylibre.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 2/3] soc: ti: Add wkup_m3_ipc driver
Message-ID: <20150105225134.GN4081@atomide.com>
References: <1420228817-41310-1-git-send-email-d-gerlach@ti.com>
 <1420228817-41310-3-git-send-email-d-gerlach@ti.com>
 <20150102201643.GE4920@saruman>
 <54AB14E4.2010607@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AB14E4.2010607@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Gerlach <d-gerlach@ti.com> [150105 14:51]:
> Felipe,
> On 01/02/2015 02:16 PM, Felipe Balbi wrote:
> > On Fri, Jan 02, 2015 at 02:00:16PM -0600, Dave Gerlach wrote:
> >> Introduce a wkup_m3_ipc driver to handle communication between the MPU
> >> and Cortex M3 wkup_m3 present on am335x.
> >>
> >> This driver is responsible for actually booting the wkup_m3_rproc and
> >> also handling all IPC which is done using the IPC registers in the control
> >> module, a mailbox, and a separate interrupt back from the wkup_m3. A small
> >> API is exposed for executing specific power commands, which include
> >> configuring for low power mode, request a transition to a low power mode,
> >> and status info on a previous transition.
> >>
> >> Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
> >> ---
> >>  drivers/soc/ti/Kconfig       |  11 ++
> >>  drivers/soc/ti/Makefile      |   1 +
> >>  drivers/soc/ti/wkup_m3_ipc.c | 451 +++++++++++++++++++++++++++++++++++++++++++
> >>  include/linux/wkup_m3_ipc.h  |  33 ++++
> >>  4 files changed, 496 insertions(+)
> >>  create mode 100644 drivers/soc/ti/wkup_m3_ipc.c
> >>  create mode 100644 include/linux/wkup_m3_ipc.h
> >>
> >> diff --git a/drivers/soc/ti/Kconfig b/drivers/soc/ti/Kconfig
> >> index 7266b21..61cda85 100644
> >> --- a/drivers/soc/ti/Kconfig
> >> +++ b/drivers/soc/ti/Kconfig
> >> @@ -28,4 +28,15 @@ config KEYSTONE_NAVIGATOR_DMA
> >>  
> >>  	  If unsure, say N.
> >>  
> >> +config WKUP_M3_IPC
> >> +	bool "TI AM33XX Wkup-M3 IPC Driver"
> > 
> > tristate ?
> 
> If we want to allow this and the rproc driver to be built as modules than we can
> change this.

Yes please, the PM is never needed early, and should be optional.
And doing that will make it a lot easier for you to do further work
on your driver ;)

And it will also make it easier to add support for other SoCs as
it seems the same M3 is used at least on am437x.
 
> > 
> >> +	depends on WKUP_M3_RPROC
> >> +	select MAILBOX
> >> +	select OMAP2PLUS_MBOX
> > 
> > selects are usually frowned upon.
> 
> Followed example set by OMAP_REMOTEPROC which selects the mailbox, thought that
> would be alright.

The select should be only done if the option selected is a silen
Kconfig option where it's never selectable by the user. Otherwise
you will errors sooner or later with make randconfig builds as the
dependencies change. Using depends on is better for those cases.

Regards,

Tony 
