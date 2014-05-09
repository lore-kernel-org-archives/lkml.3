Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaEIH5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:57:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbaEIH5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:57:13 -0400
Date: Fri, 9 May 2014 09:57:08 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] coretemp.0 folder contents changed
Message-ID: <20140509095708.0f566c34@endymion.delvare>
In-Reply-To: <536A22D2.5070104@roeck-us.net>
References: <5367C6A7.5020008@linux.intel.com>
	<20140505173231.GA25644@roeck-us.net>
	<20140506135558.3cafd062@endymion.delvare>
	<5368E45F.30301@roeck-us.net>
	<20140507091308.227d8152@endymion.delvare>
	<536A22D2.5070104@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Wed, 07 May 2014 05:10:58 -0700, Guenter Roeck wrote:
> On 05/07/2014 12:13 AM, Jean Delvare wrote:
> > On Tue, 06 May 2014 06:32:15 -0700, Guenter Roeck wrote:
> >> Can we implement a similar approach to network devices and make hwmon
> >> path names (ie the /sys/class/hwmon/XXX path name) configurable via udev ?
> >> Might be worth exploring.
> >
> > This is one possibility indeed. The good thing is that libsensors makes
> > no assumption on hwmon class device names, so we can change the names
> > without breaking any application which uses libsensors. Scripts
> > accessing sysfs directly may break though (pwmconfig would, for
> > example.)
> >
> > We'll have to be careful when choosing the new names, and make sure
> > there is no name space collision. Network interface renaming has caused
> > a great deal of trouble out there.
>
> Agreed. I'll try to find some time to play with it.
> 
> > Another approach, which I have in mind for quite some time already but
> > could never find the time to implement, would be a small helper binary
> > which would look-up hwmon devices by libsensors-like name (and the
> > other way around too.) Scripts could use it to benefit from libsensors
> > persistent names.
>
> Still needs that binary, though.

I have a proof of concept ready, I'll post it in a minute.

-- 
Jean Delvare
SUSE L3 Support
