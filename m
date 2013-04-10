Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935968Ab3DJAg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:36:28 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60987 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763199Ab3DJAg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:36:26 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 9 Apr 2013 17:36:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Subject: Re: mfd: Core driver for Winbond chips
Message-ID: <20130410003632.GA25712@roeck-us.net>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net>
 <20130322205258.GE7867@spo001.leaseweb.com>
 <20130323002810.GA26245@roeck-us.net>
 <20130323174914.GA21563@roeck-us.net>
 <20130409093700.GM24058@zurbaran>
 <20130409113639.GA8731@roeck-us.net>
 <20130409114544.GD7867@spo001.leaseweb.com>
 <20130409161838.GB27050@roeck-us.net>
 <20130409173115.GF7867@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409173115.GF7867@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 07:31:15PM +0200, Wim Van Sebroeck wrote:
> Hi Guenter,
> 
> > > > I was waiting for feedback from Wim, who submitted a similar driver, about his
> > > > thoughts. Key question is how to reserve access to the shared resource - either
> > > > through an exported function in the mfd driver requesting a mutex, or through
> > > > request_muxed_region(). I am going back and forth myself on which one is better.
> > > > 
> > > > Maybe it does not really matter, but using a function has the slight advantage
> > > > that it auto-loads and locks the mfd module while one of its client modules
> > > > is loaded. If we use request_muxed_region, that is not the case and the client
> > > > module must use another means to request and lock the mfd module.
> > > > 
> > > > Maybe you have an opinion ?
> > > 
> > > This is indeed the main issue that has to be solved. Both options will work.
> > > I like the auto-load and lock, but I need to look at the request_muxed_region
> > > code again first before I can see what the possible drawbacks are :-).
> > > 
> > One drawback of using request_muxed_region is that it needs a return value
> > from superio_enter. Also, it needs some code in the client driver init function
> > to ensure that the mfd driver gets loaded, and possibly a call to __module_get()
> > in the client driver probe function to keep the mfd driver loaded.
> > 
> > winbond_superio_enter() would not need a return value and could use
> > devm_request_region. We could also consider allocating the hwmon memory space in
> > the mfd driver and pass it as resource to the client drivers, which would remove
> > a few more lines of code from those.
> > 
> > Overall I am slightly in favor of using an exported function.
> 
> I looked at commit 8b6d043b7ee2d1b819dc833d677ea2aead71a0c0 (which implements
> request_muxed_region). You indeed need some extra code for loading the lowl-level
> mfd driver. So I am also in favour of the exported function.
> 
So which way should we go ? Take your driver as a starting point or mine ?

One thing I'll want to add is support for both superio regions, as I have a use
case for it.

Thanks,
Guenter
