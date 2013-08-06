Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab3HFOHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:07:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58006 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab3HFOHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:07:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>, rafael.j.wysocki@intel.com,
        vasilis.liaskovitis@profitbricks.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, tangchen@cn.fujitsu.com,
        wency@cn.fujitsu.com
Subject: Re: Cannot hot remove a memory device (patch, updated)
Date: Tue, 06 Aug 2013 16:17:22 +0200
Message-ID: <6353598.sj7IaxTFSj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <52005BA3.9020303@jp.fujitsu.com>
References: <51FA1E41.20304@jp.fujitsu.com> <4117925.f4JeZH8kGN@vostro.rjw.lan> <52005BA3.9020303@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 06, 2013 11:12:51 AM Yasuaki Ishimatsu wrote:
> (2013/08/06 9:15), Rafael J. Wysocki wrote:
> > On Monday, August 05, 2013 05:19:56 PM Toshi Kani wrote:
> >> On Mon, 2013-08-05 at 15:14 +0200, Rafael J. Wysocki wrote:
> >>    :
> >>> Can you please test the appended patch?  I tested it somewhat, but since the
> >>> greatest number of physical nodes per ACPI device object I can get on my test
> >>> machines is 2 (and even that after hacking the kernel somewhat), that was kind
> >>> of unconclusive.
> >>>
> >>> Thanks,
> >>> Rafael
> >>>
> >>>
> >>> ---
> >>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>> Subject: ACPI: Drop physical_node_id_bitmap from struct acpi_device
> >>>
> >>> The physical_node_id_bitmap in struct acpi_device is only used for
> >>> looking up the first currently unused phyiscal dependent node ID
> >>> by acpi_bind_one().  It is not really necessary, however, because
> >>> acpi_bind_one() walks the entire physical_node_list of the given
> >>> device object for sanity checking anyway and if that list is always
> >>> sorted by node_id, it is straightforward to find the first gap
> >>> between the currently used node IDs and use that number as the ID
> >>> of the new list node.
> >>>
> >>> This also removes the artificial limit of the maximum number of
> >>> dependent physical devices per ACPI device object, which now depends
> >>> only on the capacity of unsigend int.
> >>>
> >>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>
> >> I like the change. Much better :-)
> >>
> >> Acked-by: Toshi Kani <toshi.kani@hp.com>
> >
> > However, it introduces a bug in acpi_unbind_one(), because the size of the name
> > array in there has to be increased too.  Updated patch follows.
> >
> > Thanks,
> > Rafael
> >
> >
> > ---
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: ACPI: Drop physical_node_id_bitmap from struct acpi_device
> >
> > The physical_node_id_bitmap in struct acpi_device is only used for
> > looking up the first currently unused dependent phyiscal node ID
> > by acpi_bind_one().  It is not really necessary, however, because
> > acpi_bind_one() walks the entire physical_node_list of the given
> > device object for sanity checking anyway and if that list is always
> > sorted by node_id, it is straightforward to find the first gap
> > between the currently used node IDs and use that number as the ID
> > of the new list node.
> >
> > This also removes the artificial limit of the maximum number of
> > dependent physical devices per ACPI device object, which now depends
> > only on the capacity of unsigend int.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> I confirmed that I can add and remove a memory device correctly.

Great, thanks for the confirmation!

Rafael

