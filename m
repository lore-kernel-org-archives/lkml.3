Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3AVHHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:07:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:36799 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab3AVHHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:07:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,512,1355126400"; 
   d="scan'208";a="280372043"
Date: Tue, 22 Jan 2013 09:10:56 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lv Zheng <lv.zheng@intel.com>
Subject: Re: [PATCH 1/4] ACPI / PM: Make acpi_bus_init_power() more robust
Message-ID: <20130122071056.GB2239@intel.com>
References: <1792467.qHBR6KraFh@vostro.rjw.lan>
 <24285515.9Jp3KUo9Px@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24285515.9Jp3KUo9Px@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 03:09:01AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The ACPI specification requires the _PSC method to be present under
> a device object if its power state cannot be inferred from the states
> of power resources used by it (ACPI 5, Section 7.6.2).  However, it
> also requires that (for power states D0-D2 and D3hot) if the _PSn
> (n = 0, 1, 2, 3) method is present under the device object, it also
> must be executed after the power resources have been set
> appropriately for the device to go into power state Dn (D3 means
> D3hot in this case).  Thus it is not clear from the specification
> whether or not the _PSn method should be executed if the initial
> configuraion of power resources used by the device indicates power
> state Dn and the _PSC method is not present.
> 
> The current implementation of acpi_bus_init_power() is based on the
> assumption that it should not be necessary to execute _PSn in the
> above situation, but experience shows that in fact that assumption
> need not be satisfied.  For this reason, make acpi_bus_init_power()
> always execute _PSn if the initial configuration of device power
> resources indicates power state Dn.
> 
> Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>

You can add also,

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

if you like. Thanks for fixing this.
