Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaLCJJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:09:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaLCJJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:09:32 -0500
Date: Wed, 3 Dec 2014 10:09:28 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Pali =?UTF-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Message-ID: <20141203100928.14d23c9f@endymion.delvare>
In-Reply-To: <547DCC15.70300@roeck-us.net>
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>
	<201411291849.44032@pali>
	<20141129175152.GA32510@kroah.com>
	<201411291904.07644@pali>
	<1417526599.15239.7.camel@chaos.site>
	<547DCC15.70300@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Tue, 02 Dec 2014 06:26:29 -0800, Guenter Roeck wrote:
> On 12/02/2014 05:23 AM, Jean Delvare wrote:
> > Ultimately /proc/i8k should be killed altogether and every function
> > should use the appropriate standard interface. But I don't have any Dell
> > laptop around so I won't go into that myself.
>
> The only function not covered by hwmon, as far as I can see, is reading
> the "Fn key" status, whatever that is, and reporting the power status
> (AC or battery).
> 
> The first seems to be covered by the already existing dell drivers in
> platform/x86. The latter must be covered as well; Linux does
> display the correct power status on all my Dell laptops.

How old are they? The i8k driver is ancestral, so I could imagine that
i8k is the only way to report power status on very old Dell laptop
models. Or maybe not, I just don't know.

> Changing the ABI is not supposed to happen, so I am not sure if we can
> just drop the /proc interface.

Dropping deprecated interfaces after a transition period is not so
uncommon. AFAIK the proc interface of i8k is only used by the i8kutils
user-space package, which FWIW is no longer part of openSUSE. The
dell-laptop and dell-wmi drivers are almost 6 years old, that looks
like an already very comfortable transition period to me.

That being said, that's only my opinion and I'm not going to fight for
this. If the hwmon interface is moved to dell-laptop and i8k is killed,
I'm happy. If the i8k driver is moved to drivers/hwmon and stripped
down, I'm happy. But if none of this happens, I don't really care, to
be honest.

-- 
Jean Delvare
SUSE L3 Support
