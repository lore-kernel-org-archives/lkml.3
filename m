Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3GORx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:53:26 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:4438 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3GORxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:53:24 -0400
Date: Mon, 15 Jul 2013 19:52:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: rui.zhang@intel.com, Guenter Roeck <linux@roeck-us.net>,
        thierry.reding@gmail.com, lm-sensors@lm-sensors.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 1/4] hwmon: (lm90) split set&show temp as common
 codes
Message-ID: <20130715195252.5d2064d7@endymion.delvare>
In-Reply-To: <51E3BD5F.6060806@nvidia.com>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
	<1373615287-18502-2-git-send-email-wni@nvidia.com>
	<20130712152615.23464a6b@endymion.delvare>
	<20130712135000.GA3386@roeck-us.net>
	<20130712163034.1fc1cd66@endymion.delvare>
	<20130712144011.GC3629@roeck-us.net>
	<51E395D9.6070000@nvidia.com>
	<20130715092415.6d082aa2@endymion.delvare>
	<51E3BD5F.6060806@nvidia.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Mon, 15 Jul 2013 17:14:07 +0800, Wei Ni wrote:
> On 07/15/2013 03:24 PM, Jean Delvare wrote:
> > On Mon, 15 Jul 2013 14:25:29 +0800, Wei Ni wrote:
> >> I think we can decide it in the DT, we can add a dt property in the lm90
> >> device node, such as:
> >> sys-interface = SYS_HWMON;
> >> or
> >> sys-interface = SYS_THERMAL;
> >> So we register it as the hwmon or thermal device
> > 
> > This is an option, but please keep in mind that DT is not the only way
> > to instantiate LM90-like devices, and we should not expose duplicate
> > inputs by default. It is fine with me if the default is to create only a
> > HWMON device (as the lm90 driver was doing so far), and only
> > DT-instantiated devices have the choice.
> 
> Yes, we should not expose duplicate inputs, we may have tree permutation:
> 1. only hwmon device:
> for this items, we just need to call hwmon_device_register().
> 2. only thermal device + virtual hwmon device:
> for this items, we just need to call thermal_zone_device_register().
> 
> We can set #1 as the default, and if use DT, we provide option to choice
> #1 or #2.

#2 makes little sense IMHO, for a driver which properly implements
hwmon support. The point of the virtual hwmon device created for
thermal zones was to not put an extra burden on thermal driver authors
by asking them to additionally implement the hwmon interface. But the
hwmon interface it richer than the thermal interface in some respects
so native hwmon implementations are preferred when available. Thus I
think your option #3 below is what we want in addition to #1, and we
don't need #2.

> 3. hwmon device + thermal device:
> for this items, we doesn't need the virtual hwmon which registered by
> the thermal fw, how to handle this one? Add flag when register as
> thermal device to indicate if want virtual hwmon device or not,
> something like your below another option.

-- 
Jean Delvare
