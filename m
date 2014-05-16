Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbaEPTLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:11:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbaEPTLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:11:21 -0400
Date: Fri, 16 May 2014 21:11:17 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Pali =?ISO-8859-1?B?Um9o4XI=?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
Subject: Re: Dell Latitude E6440 & i8k
Message-ID: <20140516211117.0c766287@endymion.delvare>
In-Reply-To: <201405162037.41782@pali>
References: <201405162037.41782@pali>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali,

On Fri, 16 May 2014 20:37:41 +0200, Pali Rohár wrote:
> Hello,
> 
> on Dell Latitude E6440 driver i8k reporting total nonsense values

That's kind of excessive wording, the output isn't that bad.

> $ sensors
> i8k-virtual-0
> Adapter: Virtual device
> Right Fan:   93450 RPM
> CPU:          +57.0°C  
> temp2:        +57.0°C  
> temp3:        +40.0°C  
> temp4:       +127.0°C
> 
> Right Fan and temp4 are for sure incorrect.

Driver is reverse-engineered so this is best effort and some tweaking
may be needed.

> Value temp4 is always 127 and is never changing, but value for 
> Right Fan is increasing when fan is more noisy. So it looks like 
> value for Right Fan is not correctly normalized or multiplier is 
> incorrect.
> 
> And name "Right" is incorrect too. Fan is on left side of this 
> notebook, not right as reported by driver.
> 
> It is possible to fix these problems?

Load the i8k driver with fan_mult=1.

Add the following to /etc/sensors.d/i8k.conf:

chip "i8k-virtual-0"

   label fan2 "Left Fan"
   ignore temp4

-- 
Jean Delvare
SUSE L3 Support
