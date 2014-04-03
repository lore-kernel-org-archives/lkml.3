Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaDCNvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:51:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:23560 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbaDCNvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:51:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,787,1389772800"; 
   d="scan'208";a="513702944"
Date: Thu, 3 Apr 2014 16:58:26 +0300
From: "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-acpi@lists.linaro.org,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Linaro-acpi] How to pass I2C platform_data under ACPI
Message-ID: <20140403135826.GF19349@intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD57463568@BGSMSX104.gar.corp.intel.com>
 <D854C92F57B1B347B57E531E78D05EAD57463D21@BGSMSX104.gar.corp.intel.com>
 <20140403113832.GD19349@intel.com>
 <4539649.rsMWK1FkZ6@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4539649.rsMWK1FkZ6@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 03:34:30PM +0200, Arnd Bergmann wrote:
> On Thursday 03 April 2014 14:38:33 mika.westerberg@linux.intel.com wrote:
> > On Thu, Apr 03, 2014 at 11:25:34AM +0000, Pallala, Ramakrishna wrote:
> > > >> In non ACPI environment I used to initialize the platform_data under 
> > > >> board or platforms files. Under ACPI how do I do that?
> > > >
> > > >If you can't extract that information from ACPI namespace, then one option is to pass platform data along with the device ACPI ID:
> > > >
> > > >static const struct acpi_device_id my_acpi_match[] = {
> > > >     { "MYID0001", (kernel_ulong_t)&my_platform_data }
> > > >     ...
> > > >     { },
> > > >};
> > > 
> > > Thanks for the Quick reply.
> > > 
> > > So If I  want to use different platform_data for different boards can I
> > > do something like below?
> > 
> > Exactly.
> > 
> > > And initialize the platform data in either driver or in separate module
> > > which gets compiled along with driver?
> > 
> > Typically it has been done in the same driver but I don't see any problems
> > having a separate module as well.
> > 
> > > static const struct acpi_device_id my_acpi_match[] = {
> > >       { "MYID0001", (kernel_ulong_t)&my_platform_data1 }
> > >       { "MYID0002", (kernel_ulong_t)&my_platform_data2 }
> > >       ...
> > >       { },
> 
> We definitely don't want per-board match entries, that does not scale.
> The driver should be reasonably generic and get all the necessary data
> out of well-defined tables. You can have different IDs when there
> are only a few cases that are actually relevant, but it has to be
> conceivable that the same driver get used on future hardware without
> changes.

Yes, I meant that when the platform data information is not available in
ACPI namespace, then (and only then) pass the data by means of different
IDs.

Preferably this information is included in the ACPI namespace.
