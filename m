Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaHYGF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 02:05:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbaHYGF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 02:05:58 -0400
Date: Mon, 25 Aug 2014 14:07:13 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: lv.zheng@intel.com, matt.fleming@intel.com, linux-efi@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@acpica.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        robert.moore@intel.com
Subject: Re: kernel boot fail with efi earlyprintk (bisected)
Message-ID: <20140825060713.GA4011@darkstar.nay.redhat.com>
References: <20140819081658.GA1795@darkstar.nay.redhat.com>
 <20140821205224.GJ29733@console-pimps.org>
 <20140822100258.GA1877@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822100258.GA1877@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/14 at 06:02pm, Dave Young wrote:
> On 08/21/14 at 09:52pm, Matt Fleming wrote:
> > On Tue, 19 Aug, at 04:16:58PM, Dave Young wrote:
> > > Hi,
> > > 
> > > 3.16 kernel boot fail with earlyprintk=efi on my laptop.
> > > It keeps scrolling at the bottom line of screen.
> > > 
> > > Bisected, the first bad commit is below:
> > > commit 86dfc6f339886559d80ee0d4bd20fe5ee90450f0
> > > Author: Lv Zheng <lv.zheng@intel.com>
> > > Date:   Fri Apr 4 12:38:57 2014 +0800
> > > 
> > >     ACPICA: Tables: Fix table checksums verification before installation.
> > > 
> > > 
> > > I did some debugging by enabling both serial and efi earlyprintk, below is
> > > some debug dmesg, seems early_ioremap fails in scroll up function due to
> > > no free slot, but I'm still not sure if the debug info is right or not.
> > 
> > Thanks Dave, your callstack seems to make sense.
> > 
> > Can you also enable early_ioremap_debug so that we can figure out where
> > all the FIXMAP slots are going?
> 
> With early_ioremap_debug enabled, there will be a lot of "dropped printk", so
> I can not get any useful information.
> 
> Will try to do more debug.

early_ioremap_debug does not work because we are debugging early_printk but
early_ioremap_debug itself will print warning message at the same time.

Tried what Lv mentioned, increasing the early ioremap slots does help.

Thanks
Dave
