Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936412Ab3DILgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:36:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61912 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934856Ab3DILgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:36:35 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 9 Apr 2013 04:36:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Subject: Re: mfd: Core driver for Winbond chips
Message-ID: <20130409113639.GA8731@roeck-us.net>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net>
 <20130322205258.GE7867@spo001.leaseweb.com>
 <20130323002810.GA26245@roeck-us.net>
 <20130323174914.GA21563@roeck-us.net>
 <20130409093700.GM24058@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409093700.GM24058@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:37:01AM +0200, Samuel Ortiz wrote:
> Hi Guenter,
> 
> On Sat, Mar 23, 2013 at 10:49:14AM -0700, Guenter Roeck wrote:
> > MFD core driver for various variants of Winbond/Nuvoton SuperIO chips.
> > 
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  drivers/mfd/Kconfig          |   22 +++
> >  drivers/mfd/Makefile         |    1 +
> >  drivers/mfd/w83627hf-core.c  |  324 ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/w83627hf.h |  131 +++++++++++++++++
> >  4 files changed, 478 insertions(+)
> >  create mode 100644 drivers/mfd/w83627hf-core.c
> >  create mode 100644 include/linux/mfd/w83627hf.h
> This driver looks overall good to me. Is this your final version, or should I
> expect any follow up patch ?
> 
Hi Samuel,

I was waiting for feedback from Wim, who submitted a similar driver, about his
thoughts. Key question is how to reserve access to the shared resource - either
through an exported function in the mfd driver requesting a mutex, or through
request_muxed_region(). I am going back and forth myself on which one is better.

Maybe it does not really matter, but using a function has the slight advantage
that it auto-loads and locks the mfd module while one of its client modules
is loaded. If we use request_muxed_region, that is not the case and the client
module must use another means to request and lock the mfd module.

Maybe you have an opinion ?

Thanks,
Guenter
