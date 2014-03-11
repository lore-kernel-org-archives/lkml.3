Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaCKNMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:12:35 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59013 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753381AbaCKNMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:12:33 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: "can't evaluate _CRS: 1" messages since b355cee [ACPI / resources: ignore invalid ACPI device resources]
Date: Tue, 11 Mar 2014 14:27:52 +0100
Message-ID: <3023989.nMBYR9I9r3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <744357E9AAD1214791ACBA4B0B909263012037C7@SHSMSX103.ccr.corp.intel.com>
References: <20140311084409.GA282@x4> <1978112.3xSLQoOaC0@vostro.rjw.lan> <744357E9AAD1214791ACBA4B0B909263012037C7@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 11, 2014 01:11:19 PM Zhang, Rui wrote:
> 
> > -----Original Message-----
> > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > Sent: Tuesday, March 11, 2014 9:23 PM
> > To: Zhang, Rui
> > Cc: Markus Trippelsdorf; linux-acpi@vger.kernel.org; Wysocki, Rafael J;
> > linux-kernel@vger.kernel.org
> > Subject: Re: "can't evaluate _CRS: 1" messages since b355cee [ACPI /
> > resources: ignore invalid ACPI device resources]
> > Importance: High
> > 
> > On Tuesday, March 11, 2014 12:59:47 PM Zhang, Rui wrote:
> > > I think the reason problem is that:
> > > 1. there are zero length IO/Memory resources for these machines, and
> > for those resources
> > >    a) w/o commit b355cee88e3b1a193f0e9a81db810f6f83ad728b,
> > acpi_dev_resource_memory/io returns true
> > >    b) w commit b355cee88e3b1a193f0e9a81db810f6f83ad728b,
> > > acpi_dev_resource_memory/io returns false 2. in
> > pnpacpi_allocated_resource(), when acpi_dev_resource_memory/io()
> > returns false, it translates into "the resource is not IO/Memory
> > resource".
> > >
> > > IMO, the root cause is that the BOOL return value of
> > > acpi_dev_resource_memory/io() can not represent the following three
> > > situations
> > > 1) a valid IO/Memory resource
> > > 2) an invalid IO/Memory resource
> > > 3) not an IO/Memory resource
> > 
> > Well, can we make acpi_dev_resource_memory/io return an int, then, so
> > that it can cover all of the cases it needs to cover correctly and so
> > that we can get rid of those confusing messages?
> > 
> Sure, I will submit a patch soon.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
