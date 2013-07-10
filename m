Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3GJP7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:59:23 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:39474 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab3GJP7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:59:15 -0400
Message-ID: <51DD848E.4050206@ahsoftware.de>
Date: Wed, 10 Jul 2013 17:58:06 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 0/4] iio: hid-sensor: add module alias for autoload
References: <1373445120-5407-1-git-send-email-holler@ahsoftware.de> <51DD7D78.2020506@linux.intel.com>
In-Reply-To: <51DD7D78.2020506@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.07.2013 17:27, schrieb Srinivas Pandruvada:
> Hi,
>
> There was no intention to prevent auto loading. Did you get chance to
> test these changes?

Sure, I always test patches before I send them out.

Ok, I haven't tested the changes with the iio HID drivers (I don't have 
any commercial HID sensor hub, so I've just compile tested these patches 
here, double reading them), but I've tested the similiar changes with a 
patch for rtc-hid-sensor-time I've send out yesterday. (sorry, no link, 
lkml.org seems dead, just search for "rtc-hid-sensor-time: add module 
alias")

It works just fine. An example output is now

Jul  9 19:27:21 dockstar3 kernel: [    5.124444] rtc_hid_sensor_time 
HID-SENSOR-2000a0.0: milliseconds supported
Jul  9 19:27:21 dockstar3 kernel: [    5.132864] rtc_hid_sensor_time 
HID-SENSOR-2000a0.0: rtc core: setting system clock to 2013-07-09 
17:26:51:328000 UTC (1373390811)
Jul  9 19:27:21 dockstar3 kernel: [    5.146105] rtc_hid_sensor_time 
HID-SENSOR-2000a0.0: rtc core: registered hid-sensor-time as rtc0

Before the output was e.g.

HID-SENSOR-2000a0 HID-SENSOR-2000a0.0: rtc core: registered 
hid-sensor-time as rtc0

instead of the above with the descriptive rtc_hid_sensor_time.

Automatic loading of modules works too and it works on ARM, Intel and 
AMD as module or static linked. ;)

Regards,

Alexander Holler
