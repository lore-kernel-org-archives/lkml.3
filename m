Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3BQHbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 02:31:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:12779 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab3BQHbr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 02:31:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,682,1355126400"; 
   d="scan'208";a="263684463"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: linux-next: build failure after merge of the xen-two tree
Thread-Topic: linux-next: build failure after merge of the xen-two tree
Thread-Index: AQHODIHETyBHFMmDoE2LH83uWllZQ5h9p5rA
Date: Sun, 17 Feb 2013 07:31:37 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353FCCAC@SHSMSX101.ccr.corp.intel.com>
References: <20130215154551.d11e9d376d30d32b9673e6cc@canb.auug.org.au>
 <2185970.g9YrD945My@vostro.rjw.lan>
 <20130216015200.1e58bec1aff05592ac2ae98f@canb.auug.org.au>
 <11850955.SHqxVBsJqI@vostro.rjw.lan>
In-Reply-To: <11850955.SHqxVBsJqI@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, February 16, 2013 01:52:00 AM Stephen Rothwell wrote:
>> Hi Rafael,
> 
> Hi,
> 
>> On Fri, 15 Feb 2013 15:53:34 +0100 "Rafael J. Wysocki" <rjw@sisk.pl>
>> wrote: 
>>> 
>>> On Saturday, February 16, 2013 12:50:14 AM Stephen Rothwell wrote:
>>>> 
>>>> On Fri, 15 Feb 2013 08:26:24 -0500 Konrad Rzeszutek Wilk
>>>> <konrad.wilk@oracle.com> wrote: 
>>>>> 
>>>>> Thank you. I keep on forgetting - but would it be OK for me to
>>>>> take this patch in my tree? Or should I not since this is a new
>>>>> functionality that Rafael is going to introduce in v3.9?
>>>> 
>>>> It is an API change in the pm tree that is not yet in Linus' tree.
>>>> 
>>>>> And if so, perhaps I should tack it on in my tree, once Rafael
>>>>> does a git pull to Linus? Or just point Linus to this git commit?
>>>> 
>>>> You should point Linus at this patch if the pm tree is merged
>>>> first, or 
>>>> Rafael should do the same if the reverse happens.
>>> 
>>> Alternatively, Konrad can pull the acpi-scan branch containing the
>>> changes in question from my tree into his tree and rebase the new
>>> material on top of that.
>> 
>> Or pull the acpi-scan branch into his tree and use my conflict
>> resolution in the resulting merge thus requiring no rebasing. 
>> However, Linus likes to see such interactions, so it can be left up
>> to when the latter of the two tress is merged by Linus.
> 
> Well, I'm afraid this won't be sufficient this time, because of this
> commit in my tree (which is not on the acpi-scan branch):
> 
> commit 3757b94802fb65d8f696597a74053cf21738da0b
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Wed Feb 13 14:36:47 2013 +0100
> 
>     ACPI / hotplug: Fix concurrency issues and memory leaks
> 
> after which acpi_bus_scan() and acpi_bus_trim() have to be run under
> acpi_scan_lock (new in my tree as well).

Yes, we noticed that and only need minor updates at xen side, will send out 2 xen patches later accordingly, for cleanup and adding lock.

Thanks,
Jinsong

> 
> Moreover, I think that the introduction of ACPI-based CPU hotplug
> into Xen and this point would be premature, because we need to rework
> the original ACPI-based CPU hotplug and quite frankly it shouldn't
> call acpi_bus_scan() directly at all.
> 
> Konrad?
> 
> Thanks,
> Rafael

