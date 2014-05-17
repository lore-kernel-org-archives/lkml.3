Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbaEQJoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 05:44:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009AbaEQJoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 05:44:32 -0400
Date: Sat, 17 May 2014 11:44:29 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Pali =?ISO-8859-1?B?Um9o4XI=?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
Subject: Re: Dell Latitude E6440 & i8k
Message-ID: <20140517114429.04fc4b69@endymion.delvare>
In-Reply-To: <201405162123.02112@pali>
References: <201405162037.41782@pali>
	<20140516211117.0c766287@endymion.delvare>
	<201405162123.02112@pali>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 21:23:02 +0200, Pali Rohár wrote:
> So is not there any documentation? I think that Dell released 
> some SMM/BIOS code... But I'm not sure about it.

I don't know either. But even with some SMM/BIOS code, it doesn't tell
you which sensors are present on which machines, nor what they
correspond to, nor what scaling factors need to be applied.

> > (...)
> > Load the i8k driver with fan_mult=1.
> 
> Looks like now it reports more plausible value for fan. When fan 
> is at low it reporting between 3000 - 3100 RPM.
> 
> > Add the following to /etc/sensors.d/i8k.conf:
> > 
> > chip "i8k-virtual-0"
> > 
> >    label fan2 "Left Fan"
> >    ignore temp4
> 
> And this fixing output from sensors program.
> 
> $ sensors
> i8k-virtual-0
> Adapter: Virtual device
> Left Fan:    3088 RPM
> CPU:          +54.0°C  
> temp2:        +57.0°C  
> temp3:        +40.0°C
> 
> But Right Fan name is still present in kernel sysfs:
> 
> $ grep "" /sys/class/hwmon/hwmon1/*
> /sys/class/hwmon/hwmon1/fan2_input:3091
> /sys/class/hwmon/hwmon1/fan2_label:Right Fan
> /sys/class/hwmon/hwmon1/name:i8k
> /sys/class/hwmon/hwmon1/pwm2:128
> /sys/class/hwmon/hwmon1/temp1_input:56000
> /sys/class/hwmon/hwmon1/temp1_label:CPU
> /sys/class/hwmon/hwmon1/temp2_input:57000
> /sys/class/hwmon/hwmon1/temp3_input:40000
> /sys/class/hwmon/hwmon1/temp4_input:127000

The drivers sets default labels in sysfs, the libsensors configuration
files lets you override these defaults with your own labels.

-- 
Jean Delvare
SUSE L3 Support
