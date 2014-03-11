Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbaCKTQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:16:03 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:62552 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755258AbaCKTQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:16:01 -0400
Message-ID: <1394565357.2043.4.camel@x41>
Subject: Re: [PATCH] PNPACPI: proper handling ACPI IO/Memory resources
From: Paul Bolle <pebolle@tiscali.nl>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "jwollrath@web.de" <jwollrath@web.de>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>
Date: Tue, 11 Mar 2014 20:15:57 +0100
In-Reply-To: <744357E9AAD1214791ACBA4B0B90926301203865@SHSMSX103.ccr.corp.intel.com>
References: <1394548827-15172-1-git-send-email-rui.zhang@intel.com>
	 <744357E9AAD1214791ACBA4B0B90926301203865@SHSMSX103.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2014 19:15:59.0312 (UTC) FILETIME=[55D29D00:01CF3D5E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rui,

Zhang, Rui schreef op di 11-03-2014 om 14:50 [+0000]:
> Can you please check if this patch fixes the problem for you or not?

Yes, the two messages (one error and one warning) about "_CRS" are gone
with this patch applied on top of v3.14-rc6.

> > Before commit b355cee88e3b1a193f0e9a81db810f6f83ad728b,
> > if acpi_dev_resource_memory()/acpi_dev_resource_io() returns false, it
> > means the the resource is not a memeory/IO resource.

memeory?

> > But after commit b355cee88e3b1a193f0e9a81db810f6f83ad728b,
> > if the memory/IO resource is invalid (the length of the resource is
> > zero),
> > acpi_dev_resource_memory()/acpi_dev_resource_io() returns false as well.
> > 
> > This breaks pnpacpi_allocated_resource(), because the current code
> > would recognize the invalid memory/io resource as unknown resource type.
> > Thus users will get warning messages on machines with zero length ACPI
> > memeory/IO resources.

Ditto.
 
> > This patch fixes the problem by invoking acpi_dev_resource_memory()/
> > acpi_dev_resource_io() for ACPI memory/IO resources only.
> > 
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>

Thanks,


Paul Bolle

