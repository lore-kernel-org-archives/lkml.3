Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965776Ab3HHRQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:16:34 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26956 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965639Ab3HHRQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:16:32 -0400
Message-ID: <1375982120.10300.212.camel@misato.fc.hp.com>
Subject: Re: Cannot hot remove a memory device
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        rafael.j.wysocki@intel.com, vasilis.liaskovitis@profitbricks.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com
Date: Thu, 08 Aug 2013 11:15:20 -0600
In-Reply-To: <1375488280.10300.124.camel@misato.fc.hp.com>
References: <51FA1E41.20304@jp.fujitsu.com>
	 <2995879.KDC1gYpzij@vostro.rjw.lan>
	 <1375479975.10300.105.camel@misato.fc.hp.com>
	 <2124016.41i4c3lbD4@vostro.rjw.lan>
	 <1375488280.10300.124.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 18:04 -0600, Toshi Kani wrote:
> On Sat, 2013-08-03 at 01:43 +0200, Rafael J. Wysocki wrote:
> > On Friday, August 02, 2013 03:46:15 PM Toshi Kani wrote:
> > > On Thu, 2013-08-01 at 23:43 +0200, Rafael J. Wysocki wrote:
 :
> > > I think it fails with -EINVAL at the place with dev_warn(dev, "ACPI
> > > handle is already set\n").  When two ACPI memory objects associate with
> > > a same memory block, the bind procedure of the 2nd ACPI memory object
> > > sees that ACPI_HANDLE(dev) is already set to the 1st ACPI memory object.
> > 
> > That sound's plausible, but I wonder how we can fix that?
> > 
> > There's no way for a single physical device to have two different ACPI
> > "companions".  It looks like the memory blocks should be 64 M each in that
> > case.  Or we need to create two child devices for each memory block and
> > associate each of them with an ACPI object.  That would lead to complications
> > in the user space interface, though.
> 
> Right.  Even bigger issue is that I do not think __add_pages() and
> __remove_pages() can add / delete a memory chunk that is less than
> 128MB.  128MB is the granularity of them.  So, we may just have to fail
> this case gracefully.

FYI: I have submitted the patch blow to close this part of the issue...

https://lkml.org/lkml/2013/8/8/396

Thanks,
-Toshi


