Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab3D3P16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:27:58 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35969 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760170Ab3D3P14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:27:56 -0400
Date: Tue, 30 Apr 2013 08:27:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH 2/3 RFC] Driver core: Use generic offline/online for CPU
 offline/online
Message-ID: <20130430152753.GC8204@kroah.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
 <5608485.T3GFgtNYov@vostro.rjw.lan>
 <20130429231106.GC1333@kroah.com>
 <18234756.omYDfXWPpx@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18234756.omYDfXWPpx@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 02:01:10PM +0200, Rafael J. Wysocki wrote:
> On Monday, April 29, 2013 04:11:06 PM Greg Kroah-Hartman wrote:
> > On Mon, Apr 29, 2013 at 02:28:02PM +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > Rework the CPU hotplug code in drivers/base/cpu.c to use the
> > > generic offline/online support introduced previously instead of
> > > its own CPU-specific code.
> > > 
> > > For this purpose, modify cpu_subsys to provide offline and online
> > > callbacks for CONFIG_HOTPLUG_CPU set and remove the code handling
> > > the CPU-specific 'online' sysfs attribute.
> > > 
> > > This modification is not supposed to change the user-observable
> > > behavior of the kernel (i.e. the 'online' attribute will be present
> > > in exactly the same place in sysfs and should trigger exactly the
> > > same actions as before).
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >  drivers/base/cpu.c |   62 ++++++++++++-----------------------------------------
> > >  1 file changed, 15 insertions(+), 47 deletions(-)
> > 
> > Very nice, I like reductions like this :)
> 
> Thanks!
> 
> So I guess the patches make sense to you overall?

Overall, yes, I like them a lot.

greg k-h
