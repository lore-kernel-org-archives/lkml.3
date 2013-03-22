Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423058Ab3CVUxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:53:02 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:40311 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423029Ab3CVUxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:53:00 -0400
Date: Fri, 22 Mar 2013 21:52:58 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Subject: Re: [PATCH v2 0/8] watchdog: w83627hf: Convert to watchdog infrastructure
Message-ID: <20130322205258.GE7867@spo001.leaseweb.com>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362957300-18223-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> Convert to watchdog infrastructure, cleanup, add support for additional
> chips, and merge with W83697HF and W83697UG watchdog drivers.
> 
> Tested with W83627UHG, NCT6775, NCT6776. Additional test feedback
> for other chips would be appreciated.
> 
> Original idea was to prepare the driver for use as a client to an MFD driver,
> but I found that requesting memory with request_muxed_region works just as well
> and has less impact. v2 includes the knowledge gained from converting the
> driver to an MFD client driver, but without the actual conversion.
> 
> v2: Tested with W83627UHG
>     Retain timeout module parameter; use watchdog_init_timeout to set it
>     Eliminate some cosmetic changes
>     Drop spinlock.h include
>     Keep "initialized" message
>     Don't try to configure WDTO for W83627UHG and W83627EHF
>     Don't report the nowayout option with the 'initializing' message
>     Use request_muxed_region to reserve memory range only while needed
>     Add support for W83627S, W83627DHG-P, W83667HG, and NCT6779

In 2011 I started something similar but then with the MFD approach in mind.
Goal was also to clean-up the w836* watchdog drivers and get a clean driver that
supports all Winbond super-I/O based watchdog drivers.

I dug op the development code again. I'll post it in a next e-mail so that we can
see what the best way forward is. Note: I took the MFD approach because:
1) all superio shares the similar functions for using the Super-I/O registers.
2) Goal is to have low-level driver that support the specific super-I/O chipsets
and that does the platform stuff for hwmon, watchdog, gpio, ...

Kind regards,
Wim.

