Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab3HTM2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:28:18 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51377 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab3HTM2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:28:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jerry Snitselaar <jerry.snitselaar@oracle.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] acpi_i2c: set MODULE_LICENSE, MODULE_AUTHOR, and MODULE_DESCRIPTION
Date: Tue, 20 Aug 2013 14:38:50 +0200
Message-ID: <3534926.AiYWyl8db9@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130820081852.GV4898@intel.com>
References: <1376702795-25912-1-git-send-email-jerry.snitselaar@oracle.com> <20130820081442.GU4898@intel.com> <20130820081852.GV4898@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 20, 2013 11:18:52 AM Mika Westerberg wrote:
> On Tue, Aug 20, 2013 at 11:14:42AM +0300, Mika Westerberg wrote:
> > On Tue, Aug 20, 2013 at 01:00:08AM -0700, Jerry Snitselaar wrote:
> > > On Tue Aug 20 13, Mika Westerberg wrote:
> > > > On Mon, Aug 19, 2013 at 08:34:03PM -0700, Jerry Snitselaar wrote:
> > > > > On Tue Aug 20 13, Rafael J. Wysocki wrote:
> > > > > > On Monday, August 19, 2013 04:35:29 PM Jerry Snitselaar wrote:
> > > > > > > On Tue Aug 20 13, Rafael J. Wysocki wrote:
> > > > > > > > On Monday, August 19, 2013 09:16:14 AM Mika Westerberg wrote:
> > > > > > > > > On Fri, Aug 16, 2013 at 06:26:35PM -0700, Jerry Snitselaar wrote:
> > > > > > > > > > Without MODULE_LICENSE set, I get the following with modprobe:
> > > > > > > > > > 
> > > > > > > > > > acpi_i2c: module license 'unspecified' taints kernel.
> > > > > > > > > > acpi_i2c: Unknown symbol i2c_new_device (err 0)
> > > > > > > > > > acpi_i2c: Unknown symbol acpi_dev_get_resources (err 0)
> > > > > > > > > > acpi_i2c: Unknown symbol acpi_dev_resource_interrupt (err 0)
> > > > > > > > > > acpi_i2c: Unknown symbol acpi_dev_free_resource_list (err 0)
> > > > > > > > > > 
> > > > > > > > > > Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
> > > > > > > > > 
> > > > > > > > > Looks good to me.
> > > > > > > > > 
> > > > > > > > > Acked-by: Mika Westerbeg <mika.westerberg@linux.intel.com>
> > > > > > > > 
> > > > > > > > Well, OK, but do we need to be able to build that as a module?
> > > > > > > > 
> > > > > > > > Maybe it should just be yes or no?
> > > > > > > > 
> > > > > > > > Rafael
> > > > > > > > 
> > > > > > > 
> > > > > > > Perhaps have depends on I2C=y and be a bool instead of tristate?
> > > > > > 
> > > > > > Yes, that's the idea.
> > > > > > 
> > > > > Does this look okay Mika?
> > > > > 
> > > > > [PATCH] acpi_i2c: do not build as loadable module
> > > > > 
> > > > > Change from tristate to bool, and depend on I2C=y
> > > > 
> > > > I'm not sure about this. Does the below mean that we can't build the ACPI
> > > > I2C enumeration at all if I2C core is compiled as module?
> > > 
> > > Yes, that was what Rafael was suggesting. If the ability to compile as
> > > a module if I2C is a module is needed, then we need the 1st patch.
> > 
> > In that case I would prefer the first patch. Otherwise we lose the ability
> > to enumerate I2C devices from ACPI namespace on some distros (at least
> > Debian builds I2C core as a module).
> > 
> > Rafael?
> 
> Actually there's a patch that moves DT I2C helpers to the I2C core here:
> 
> https://lkml.org/lkml/2013/8/19/349
> 
> we should probably do the same for the ACPI case. Doing that solves this
> problem as well.

Yes, and I'd prefer it to be done this way.  Having ACPI support as a separate
module doesn't really buy us anything.

Thanks,
Rafael

