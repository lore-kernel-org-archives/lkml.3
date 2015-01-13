Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbbAMRAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:00:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:6278 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbbAMRAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:00:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="636693762"
Date: Tue, 13 Jan 2015 19:00:07 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c / ACPI: Pick the first address if device has multiple
Message-ID: <20150113170007.GV1386@lahna.fi.intel.com>
References: <1419860928-195404-1-git-send-email-mika.westerberg@linux.intel.com>
 <20150113155059.GN7660@katana>
 <1421167477.4459.229.camel@spandruv-desktop.jf.intel.com>
 <20150113164829.GO7660@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113164829.GO7660@katana>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 05:48:29PM +0100, Wolfram Sang wrote:
> On Tue, Jan 13, 2015 at 08:44:37AM -0800, Srinivas Pandruvada wrote:
> > On Tue, 2015-01-13 at 16:50 +0100, Wolfram Sang wrote: 
> > > On Mon, Dec 29, 2014 at 03:48:48PM +0200, Mika Westerberg wrote:
> > > > ACPI specification allows I2C devices with multiple addresses. The current
> > > > implementation goes over all addresses and assigns the last one to the
> > > > device. This is typically not the primary address of the device.
> > > > 
> > > > Instead of doing that we assign the first address to the device and then
> > > > let the driver handle rest of the addresses as it wishes.
> > > > 
> > > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > > Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> > > 
> > > Yes, seems better than what we do know. But maybe taking the lowest
> > > address is a bit better heuristic than taking the first address?
> > > Not sure, though...
> > The problem in taking lowest is that in many cases in current devices,
> > the lowest address may end being 0x0C, which is reserved address for
> > SMBUS (ARA). This will require different handling. Unfortunately ACPI
> > doesn't have a way to distinguish whether SMBUS support is desired or
> > not. 
> > The other option is to skip all reserved addresses for SMBUS also and
> > then create on the lowest.
> 
> Well, this makes me think that Mika's approach is probably the sanest
> one...

Also I think it is more consistent that way.
