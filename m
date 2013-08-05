Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3HEXVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 19:21:08 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:8994 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab3HEXVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 19:21:05 -0400
Message-ID: <1375744796.10300.175.camel@misato.fc.hp.com>
Subject: Re: Cannot hot remove a memory device (patch)
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        rafael.j.wysocki@intel.com, vasilis.liaskovitis@profitbricks.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com
Date: Mon, 05 Aug 2013 17:19:56 -0600
In-Reply-To: <1456797.BR6oLAipWK@vostro.rjw.lan>
References: <51FA1E41.20304@jp.fujitsu.com>
	 <51FF2368.9060206@jp.fujitsu.com> <51FF5B58.7050701@jp.fujitsu.com>
	 <1456797.BR6oLAipWK@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 15:14 +0200, Rafael J. Wysocki wrote:
  :
> Can you please test the appended patch?  I tested it somewhat, but since the
> greatest number of physical nodes per ACPI device object I can get on my test
> machines is 2 (and even that after hacking the kernel somewhat), that was kind
> of unconclusive.
> 
> Thanks,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI: Drop physical_node_id_bitmap from struct acpi_device
> 
> The physical_node_id_bitmap in struct acpi_device is only used for
> looking up the first currently unused phyiscal dependent node ID
> by acpi_bind_one().  It is not really necessary, however, because
> acpi_bind_one() walks the entire physical_node_list of the given
> device object for sanity checking anyway and if that list is always
> sorted by node_id, it is straightforward to find the first gap
> between the currently used node IDs and use that number as the ID
> of the new list node.
> 
> This also removes the artificial limit of the maximum number of
> dependent physical devices per ACPI device object, which now depends
> only on the capacity of unsigend int.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

I like the change. Much better :-)

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


