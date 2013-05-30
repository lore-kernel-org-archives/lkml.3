Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968075Ab3E3Ji6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:38:58 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:48086 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3E3Jiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:38:50 -0400
Date: Thu, 30 May 2013 11:38:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: anish singh <anish198519851985@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: What is listed in /sys/module?
Message-ID: <20130530113838.32ff2632@endymion.delvare>
In-Reply-To: <CAK7N6vo+2F98CfibfTUn9fbkxEXjBVQi1cxpvK0L7XCSq8xaDQ@mail.gmail.com>
References: <20130529102735.3ce72ecc@endymion.delvare>
	<878v2xmgmw.fsf@rustcorp.com.au>
	<CAK7N6vpv6JpsXEdjLOUd-+7+y=DB9Q-zcMdj12iZWu=bGkAieQ@mail.gmail.com>
	<20130530103444.40888460@endymion.delvare>
	<CAK7N6vo+2F98CfibfTUn9fbkxEXjBVQi1cxpvK0L7XCSq8xaDQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anish,

On Thu, 30 May 2013 14:56:43 +0530, anish singh wrote:
> On Thu, May 30, 2013 at 2:04 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > My question was motivated by work I'm doing on the sensors-detect
> > script. The purpose of that script is to tell the user which modules
> > he/she should load to get hardware monitoring running on his/her
> > system. The script has to load some modules for the detection itself
> > (e.g. cpuid, i2c-dev, SMBus controller drivers) and outputs a list of
> > drivers which should be loaded by the user (but the script itself does
> > not load them.)
> >
> > Each of the drivers in question can be completely missing, or built-in,
> > or built as a module but not loaded, or built as a module and loaded.
> > In order to make the script as user-friendly as possible, we have to
> > handle each case properly. If the driver is missing, we want to tell
> > the user that we can't do the detection completely (if the driver was
> > needed for probing) or he/she won't be able to make full use of the
> > hardware (if the driver was needed for run-time.) If the driver is
> > built-in or already loaded module, then all is fine, we don't have to
> > load it (for probing) nor to tell the user to do it (for run-time.) If
> > the driver is modular, we have to load and then unload it (for probing)
> > or tell the user to do so (for run-time.) So we have 4 cases to handle:
> >
> > 1* Driver missing
> > 2* Driver built-in
> > 3* Module not loaded
> > 4* Module loaded
> >
> > Case 4 is the easy one, we just look at /proc/modules. But having no
> > way to tell if a given driver is built-in, makes it impossible to
> 
>  modprobe -l doesn't work?

I am reluctant to use an option which is described as "is provided for
backwards compatibility and may go away in future" in the manual page.
Leaving that aside for the sake of the discussion, I can't see how it
solves my problem anyway, as modprobe -l will return nothing in both
case 1 (driver missing) and case 2 (driver built-in) so it won't let me
distinguish between the two.

So I'm going to use modules.builtin.

-- 
Jean Delvare
