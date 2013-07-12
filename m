Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab3GLOat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 10:30:49 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:7209 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab3GLOas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 10:30:48 -0400
Date: Fri, 12 Jul 2013 16:30:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wei Ni <wni@nvidia.com>, thierry.reding@gmail.com,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 1/4] hwmon: (lm90) split set&show temp as common
 codes
Message-ID: <20130712163034.1fc1cd66@endymion.delvare>
In-Reply-To: <20130712135000.GA3386@roeck-us.net>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
	<1373615287-18502-2-git-send-email-wni@nvidia.com>
	<20130712152615.23464a6b@endymion.delvare>
	<20130712135000.GA3386@roeck-us.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Fri, 12 Jul 2013 06:50:00 -0700, Guenter Roeck wrote:
> On Fri, Jul 12, 2013 at 03:26:15PM +0200, Jean Delvare wrote:
> > One thing I am a little worried about (but maybe I'm wrong) is that I
> > seem to understand you want to register every LM90-like chip as both a
> > hwmon device and two thermal devices. I seem to recall that every
> > thermal device is also exposed automatically as a virtual hwmon
> > device, is that correct? If so we will be presenting the same values
> > twice to libsensors, which would be confusing.
> 
> Not sure if that is a good idea, but if I recall correctly, the thermal folks
> plan to remove that path.

If that means that for example the ACPI thermal zone is no longer
displayed by "sensors", then I strongly object - unless it is
explicitly registered as a separate hwmon device from now on, of course.

My idea was to make the bridge optional - you decide when you register
a thermal device if it should be exposed as hwmon or not.

I don't have a strong opinion on the implementation, as long as each
input is listed by "sensors" once and only once.

-- 
Jean Delvare
