Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaKGLFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:05:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:49329 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbaKGLFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:05:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="412951274"
Date: Fri, 7 Nov 2014 13:05:47 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lan Tianyu <tianyu.lan@intel.com>, lenb@kernel.org, wsa@the-dreams.de,
        robert.moore@intel.com, lv.zheng@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devel@acpica.org
Subject: Re: [RFC PATCH V2] ACPI: Add _DEP(Operation Region Dependencies)
 support to fix battery issue on the Asus T100TA
Message-ID: <20141107110547.GT1618@lahna.fi.intel.com>
References: <1414422584-2638-1-git-send-email-tianyu.lan@intel.com>
 <7320898.JB9z5hUzdG@vostro.rjw.lan>
 <20141106061952.GC1618@lahna.fi.intel.com>
 <1576552.2oedNFkf9R@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576552.2oedNFkf9R@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 12:00:34AM +0100, Rafael J. Wysocki wrote:
> > So if we have a device, like SDHB above (SDIO controller), that needs
> > GPIOs for powering the SDIO card and that is done by using GPIO
> > operation regions how do we ensure that the GPIO controller driver is
> > there?
> > 
> > I think the answer is that we just make sure the the GPIO driver is
> > there before anything that is going to use it. E.g make it
> > subsys_initcall() or so?
> 
> The current approach, which arguably is lame, has been to (1) compile in
> all drivers that *may* be depended on (like all drviers registering operation
> region handlers) and then (2) trick the devices to be registered in the right
> order.

Right, I kind of expected that it be the case :-/
 
> I'd rather have a more robust mechanism than that, but so far no one has
> proposed anything remotely usable.
> 
> As far as _DEP is concerned, it seems that in *practice* it is used to
> reflect functional dependencies between devices rather than the operation
> regions thing only (as specified).  In that case we may decide to follow
> the practice rather than the spec (and move to update the spec to reflect
> the practice at the same time), but that requires some consideration.

Indeed it looks very much that it contains more than just operation
depedencies. In T100 for example there is this PEPD device that does not
have any operation regions and it is still in the _DEP list of the SDIO
controller device.
