Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaEERck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:32:40 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50916 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaEERcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:32:39 -0400
Date: Mon, 5 May 2014 10:32:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: coretemp.0 folder contents changed
Message-ID: <20140505173231.GA25644@roeck-us.net>
References: <5367C6A7.5020008@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5367C6A7.5020008@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 10:13:11AM -0700, Srinivas Pandruvada wrote:
> Hi,
> 
> for kernel : 3.15.rc3 .
> 
> Is there any change in the coretemp? Previously we used to see,
> tempx data (like temp2_input, temp2_max etc.)
> /sys/devices/platform/coretemp.0/.
> 
That isn't where you are supposed to look for hwmon attributes.

> Now We don't see them. Now we have to go
> /sys/devices/platform/coretemp.0/hwmon/hwmon?/ to get these values.
> 
This is also not the correct location.

You should be looking in /sys/class/hwmon/hwmonX/.

There will be a name attribute either in /sys/class/hwmon/hwmonX/name
or in /sys/class/hwmon/hwmonX/device/name. For coretemp, the value
reported in the name attribute will be 'coretemp'. This defines the
directory where the actual sensor attributes will be located.

A better approach might be to use libsensors instead of directly
accessing attributes.

To give you the background, hwmon attributes are in the process of
being moved from the parent device to the hwmon device, or from
/sys/class/hwmon/hwmonX/device/ to /sys/class/hwmon/hwmonX/,
as part of an effort to streamline the code and make it more
consistent and maintainable.

Guenter
