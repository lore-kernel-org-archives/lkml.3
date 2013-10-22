Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3JVSwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:52:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:59655 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab3JVSwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:52:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="423060528"
Date: Tue, 22 Oct 2013 11:50:04 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] drivers/misc: add rawio framework and drivers
Message-ID: <20131022185004.GC53231@bingao-desk1.fm.intel.com>
References: <5265C0C5.70905@linux.intel.com>
 <20131022054406.GA14163@kroah.com>
 <20131022171400.GA14558@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022171400.GA14558@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 10:14:00AM -0700, Guenter Roeck wrote:
> > 
> > You can already do this today for PCI with the UIO framework, right?
> > Why duplicate that functionality here with another userapce API that we
> > will then have to maintain for the next 40+ years?
> > 
> Same for i2c, where the same functionality is supported through i2c-tools and
> the i2c-dev driver. Adding i2c-tools to initramfs and/or to the root file system
> should not be that much of an issue, much less than having to maintain two APIs
> for the same purpose.
> 
> Guenter

For PCI and memory mapped I/O devices, we have the runtime pm issue that has to
be addressed from kernel space.
For I2C slave devices, there is no such a issue so yes i2c-tools and i2c-dev drivers
are fine. But the two APIs are required by PCI and memory mapped I/O devices anyway.
