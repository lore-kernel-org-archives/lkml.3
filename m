Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3HaATM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 20:19:12 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:30356 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab3HaATK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 20:19:10 -0400
Message-ID: <1377908257.10300.896.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/3] ACPI / scan: Change ordering of locks for device
 hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, linux-mm@kvack.org
Date: Fri, 30 Aug 2013 18:17:37 -0600
In-Reply-To: <1752041.76DW3TEE1A@vostro.rjw.lan>
References: <9589253.Co8jZpnWdd@vostro.rjw.lan>
	 <1752041.76DW3TEE1A@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 23:15 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Change the ordering of device hotplug locks in scan.c so that
> acpi_scan_lock is always acquired after device_hotplug_lock.
> 
> This will make it possible to use device_hotplug_lock around some
> code paths that acquire acpi_scan_lock safely (most importantly
> system suspend and hibernation).  Apart from that, acpi_scan_lock
> is platform-specific and device_hotplug_lock is general, so the
> new ordering appears to be more appropriate from the overall
> design viewpoint.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


