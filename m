Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaEQVJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 17:09:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbaEQVJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 17:09:44 -0400
Date: Sat, 17 May 2014 23:09:40 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Pali =?ISO-8859-1?B?Um9o4XI=?= <pali.rohar@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Dell Latitude E6440 & i8k
Message-ID: <20140517230940.25c36f07@endymion.delvare>
In-Reply-To: <53777F72.3000907@roeck-us.net>
References: <201405162037.41782@pali>
	<20140516211117.0c766287@endymion.delvare>
	<53777F72.3000907@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2014 08:25:38 -0700, Guenter Roeck wrote:
> On 05/16/2014 12:11 PM, Jean Delvare wrote:
> > Load the i8k driver with fan_mult=1.
> 
> Would it make sense to change the default multiplier to 1 ?
> Lots of people have problems with it, and trying to figure out
> affected machines one by one would be an all but impossible task.

That would cause a regression on many (presumably older) machines. I
doubt this is acceptable. One option would be to use the ACPI year to
change the default, if indeed all new machines need fan_mult=1. I don't
know if this is the case.

One this I had in mind was auto-detecting the scaling factor. AFAIK
only 30 and 1 are possible values, so any value above ~300 would imply
scaling factor of 1 (30 would make it > 9000 RPM which is unrealistic.)
But I don't know if we can actually do that, as such a simple heuristic
could easily fail is the fan is stopped (30 * 0 == 1 * 0) or if the
returned raw speed is temporarily unreliable for whatever reason.

I have to admit that working on a reverse engineered driver for
hardware I don't even have isn't quite at the top of my to-do list.

-- 
Jean Delvare
SUSE L3 Support
