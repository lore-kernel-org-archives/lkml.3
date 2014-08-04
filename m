Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaHDIoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:44:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaHDIoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:44:22 -0400
Subject: Re: [PATCH 4/4] Return the fan speed via sysfs
From: Jean Delvare <jdelvare@suse.de>
To: kreijack@inwind.it
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, bryan@whatroute.net
In-Reply-To: <53DE6667.8070901@gmail.com>
References: <1406901650-20841-1-git-send-email-kreijack@inwind.it>
	 <1406901650-20841-5-git-send-email-kreijack@inwind.it>
	 <20140803161738.485f3f60@endymion.delvare>	<53DE54D5.2050806@inwind.it>
	 <20140803175901.27519306@endymion.delvare>  <53DE6667.8070901@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 04 Aug 2014 10:44:12 +0200
Message-ID: <1407141852.4302.8.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sunday 03 August 2014 à 18:42 +0200, Goffredo Baroncelli a écrit :
> On 08/03/2014 05:59 PM, Jean Delvare wrote:
> > The temperature attributes in hwmon would need different names and
> > units too (temp1_input and temp2_input, in millidegree C.) The
> > advantage is that all monitoring applications out there would pick up
> > these values automatically.
> 
> Are you suggesting to add also a "temp1_input" attribute ?

Yes, but as a hwmon class device attribute, not as an attribute
in /sys/devices/temperature.

> >> I even thought to allow to change the fan speed from user space....
> > 
> > Ben will never let you do that ;-)
> 
> What would be the risk ?. When the CPU temperature goes behind the limit, 
> then the computer is switched off by an hardware protection (I am sure because
> I had to changed a cpu board because a drift of the temperature sensor).

And you are still asking what the risk is? ;-)

> I am not suggesting to allow to change the fan speed, I am only asking which would
> be the risk.

If the user forces the fan too low, the system can overheat, and that
can result in user injury or hardware damage (or reduced lifetime of
hardware, at least.)

Some people think that the user should always be given full power over
his/her hardware. Others think that hardware should just work and users
should never have to care about such low-level details.

In this specific case I'd say don't change it unless you have a
compelling reason to.

-- 
Jean Delvare
SUSE L3 Support

