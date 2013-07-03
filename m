Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806Ab3GCPIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 11:08:52 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:47602 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab3GCPIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 11:08:51 -0400
Date: Wed, 3 Jul 2013 17:08:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] 3.10: Intel HWMON/NIC temperature sensor question
Message-ID: <20130703170838.326894c6@endymion.delvare>
In-Reply-To: <20130703144845.GB10323@roeck-us.net>
References: <002401ce77e9$da6524b0$8f2f6e10$@lucidpixels.com>
	<20130703144845.GB10323@roeck-us.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jul 2013 07:48:45 -0700, Guenter Roeck wrote:
> 82575 and 82599. Doesn't matter much, though, since they don't export the "name"
> attribute from their driver, meaning the sensors command won't find the sensors.
> Also, they enerate the hwmon device first and then create the attributes, which
> is the wrong order and creates a potential race condition with demons.

Yes and no. For devices which are only implementing hwmon features,
hwmon is just a link and the attributes belong to the device. So we can
create the attributes first and the hwmon device second.

However for devices which are primarily something else and only
register a hwmon device as a side object, the hwmon attributes are
attached to the hwmon class device and not the main device. In that
case the hwmon device has to be created first and the attributes
second. Yes, this is racy. The only clean way around it AFAIK is to
implement all the attributes as proper class attributes rather than
creating them manually - but it would take a whole redesign of the
hwmon core module.

A workaround may be to create the name attribute last.

> Someone who has a board will have to fix that at some point.

-- 
Jean Delvare
