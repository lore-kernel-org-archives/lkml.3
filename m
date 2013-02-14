Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726Ab3BNOoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:44:08 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54690 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934614Ab3BNOoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:44:06 -0500
Date: Thu, 14 Feb 2013 15:44:04 +0100
From: Andreas Mohr <andi@lisas.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [ASAP] thermal_sys.c NULL ptr deref patch likely incomplete
Message-ID: <20130214144404.GA20011@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just had a

# cat /sys/class/thermal/thermal_zone0/policy 
(null)


When looking at the code (on my -rc7), I saw:

drivers/thermal/thermal_sys.c

static ssize_t
policy_show(struct device *dev, struct device_attribute *devattr, char
*buf)
{
        struct thermal_zone_device *tz = to_thermal_zone(dev);

        return sprintf(buf, "%s\n", tz->governor->name);
}


(not sure though why I manage to get a "(null)" rather than a crash
due to the dereferencing prior to output - possibly since I do have a
valid governor allocated yet then only its name field is null?)


Seems we are missing a critical (and -rc-relevant) patch here
(and perhaps at other locations in this file, too, given that
this one was missed last time?).

Currently trying to get acerhdf operation into a working state
(and having some trouble with it - didn't know that I probably need some
governor setup which seems to have just been available on my last setup,
or so)

Thanks,

Andreas Mohr
