Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbbA0WfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:35:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651AbbA0WfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:35:09 -0500
Date: Tue, 27 Jan 2015 23:34:55 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Robert Rosengren <robert.rosengren@axis.com>, lm-sensors@lm-sensors.org,
        Johan Adolfsson <johana@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (ads7828) Make sample interval
 configurable
Message-ID: <20150127233455.0c62457e@endymion.delvare>
In-Reply-To: <20150127200553.GA5689@roeck-us.net>
References: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com>
	<54B92596.2040206@roeck-us.net>
	<20150116183020.GA6262@roeck-us.net>
	<54C74567.9020201@axis.com>
	<54C79B87.8040607@roeck-us.net>
	<4BEA3FF3CAA35E408EA55C7BE2E61D05943B6DD753@xmail3.se.axis.com>
	<20150127200553.GA5689@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 12:05:53 -0800, Guenter Roeck wrote:
> On Tue, Jan 27, 2015 at 08:54:34PM +0100, Robert Rosengren wrote:
> > Guenter and Jean, 
> > 
> > To sum up, my problems was related my kernel and hardware configuration, and it now works. Many thanks for your input!
> > 
> > However, the values retrieved from hwmon sysfs is not the same as before the regmap patch. Guenter, the byte swap for the regval retrieved by regmap_read. In what order is the bits returned from that function, because it seems as if I disabled that code I get values as I expect (i.e. before the regmap patch).
> > 
> Trying to understand. Are you saying everything works as expected
> if you keep byte_swap set to false ?
> 
> That might well be, though it might mean that regmap has a bug
> in how it treats i2c word read operations. I'll have to look into it 
> some more.

Remember that SMBus specifies that the LSB comes first (and i2c-core
implement things that way) while real I2C devices typically send the MSB
first. This has always caused confusion. This is why a lot of drivers
need byte-swapping.

-- 
Jean Delvare
SUSE L3 Support
