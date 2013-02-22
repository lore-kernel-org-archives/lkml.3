Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3BVIWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:22:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:56193 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3BVIWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:22:19 -0500
Date: Fri, 22 Feb 2013 09:22:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Huang Ying <ying.huang@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG bisected]: apei_hest_parse explosion
In-Reply-To: <4867361.uTndA5QxsU@vostro.rjw.lan>
Message-ID: <alpine.LFD.2.02.1302220903000.22263@ionos>
References: <alpine.LFD.2.02.1302220002040.22263@ionos> <CAE9FiQXV43emyjjCb=D=xFLz-n6q0Eu0uQmVhAA470A=FGRhww@mail.gmail.com> <3310807.g9DvzzvEFn@vostro.rjw.lan> <4867361.uTndA5QxsU@vostro.rjw.lan>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Rafael J. Wysocki wrote:
> On Friday, February 22, 2013 02:40:58 AM Rafael J. Wysocki wrote:
> > It looks like the hest_tab memory mapping is unmapped between acpi_hest_init()
> > and aer_acpi_firmware_first(), but I have no idea what may be responsible for
> > that.
> > 
> > And the only relevant difference between now and before the commit above seems
> > to be the change of the acpi_hest_init() ordering (which now is called earlier).
> 
> We actually don't really need to do that thing so early, I think.  It looks like
> we only need to make it available early enough for the AER driver to be able to
> use it, so I wonder if moving the acpi_hest_init() to a separate
> subsys_initcall() will work around the problem.  That is, something like the
> patch below.

Yes, that makes the machine boot.
 
> But even if this helps, I will be wanting to understand what's up here.

It's very simple. I have "acpi=off" on the command line. With that
acpi_hest_init is never called, so hest_disable is not set .....

Brilliant stuff that.
