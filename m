Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3GOHYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 03:24:41 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:45603 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3GOHYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 03:24:39 -0400
Date: Mon, 15 Jul 2013 09:24:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: Guenter Roeck <linux@roeck-us.net>, <rui.zhang@intel.com>,
        thierry.reding@gmail.com, lm-sensors@lm-sensors.org,
        <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 1/4] hwmon: (lm90) split set&show temp as common
 codes
Message-ID: <20130715092415.6d082aa2@endymion.delvare>
In-Reply-To: <51E395D9.6070000@nvidia.com>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
	<1373615287-18502-2-git-send-email-wni@nvidia.com>
	<20130712152615.23464a6b@endymion.delvare>
	<20130712135000.GA3386@roeck-us.net>
	<20130712163034.1fc1cd66@endymion.delvare>
	<20130712144011.GC3629@roeck-us.net>
	<51E395D9.6070000@nvidia.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013 14:25:29 +0800, Wei Ni wrote:
> On 07/12/2013 10:40 PM, Guenter Roeck wrote:
> > On Fri, Jul 12, 2013 at 04:30:34PM +0200, Jean Delvare wrote:
> >> If that means that for example the ACPI thermal zone is no longer
> >> displayed by "sensors", then I strongly object - unless it is
> >> explicitly registered as a separate hwmon device from now on, of course.
> >
> > If I recall correctly that was the idea. Of course, in practice that will mean
> > that devices will _not_ get exposed as hwmon devices, as implementers won't
> > bother doing both.
> > 
> >> My idea was to make the bridge optional - you decide when you register
> >> a thermal device if it should be exposed as hwmon or not.
> >
> > Yes, that would be a much better solution.
> 
> I think we can decide it in the DT, we can add a dt property in the lm90
> device node, such as:
> sys-interface = SYS_HWMON;
> or
> sys-interface = SYS_THERMAL;
> So we register it as the hwmon or thermal device

This is an option, but please keep in mind that DT is not the only way
to instantiate LM90-like devices, and we should not expose duplicate
inputs by default. It is fine with me if the default is to create only a
HWMON device (as the lm90 driver was doing so far), and only
DT-instantiated devices have the choice.

Another option, as discussed before, would be that the thermal devices
registered by lm90 are specifically tagged as "do not expose as hwmon".
This would avoid the duplicate hwmon inputs in all cases.

Again - no strong opinion on the implementation, as long as it does the
right thing.

Oh, and we'll have to be careful with the Kconfig dependencies. I do
not want the lm90 driver to depend on the thermal framework.

-- 
Jean Delvare
