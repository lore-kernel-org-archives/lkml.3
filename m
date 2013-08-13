Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab3HMOqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:46:06 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:44631 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3HMOqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:46:05 -0400
Message-ID: <1376405088.10300.384.camel@misato.fc.hp.com>
Subject: Re: [PATCH] mm/hotplug: Remove stop_machine() from
 try_offline_node()
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, liwanp@linux.vnet.ibm.com
Date: Tue, 13 Aug 2013 08:44:48 -0600
In-Reply-To: <3940091.8hz2Z6IIgz@vostro.rjw.lan>
References: <1376336071-9128-1-git-send-email-toshi.kani@hp.com>
	 <3940091.8hz2Z6IIgz@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 13:41 +0200, Rafael J. Wysocki wrote:
> On Monday, August 12, 2013 01:34:31 PM Toshi Kani wrote:
> > lock_device_hotplug() serializes hotplug & online/offline operations.
> > The lock is held in common sysfs online/offline interfaces and ACPI
> > hotplug code paths.
> > 
> > try_offline_node() off-lines a node if all memory sections and cpus
> > are removed on the node.  It is called from acpi_processor_remove()
> > and acpi_memory_remove_memory()->remove_memory() paths, both of which
> > are in the ACPI hotplug code.
> > 
> > try_offline_node() calls stop_machine() to stop all cpus while checking
> > all cpu status with the assumption that the caller is not protected from
> > CPU hotplug or CPU online/offline operations.  However, the caller is
> > always serialized with lock_device_hotplug().  Also, the code needs to
> > be properly serialized with a lock, not by stopping all cpus at a random
> > place with stop_machine().
> > 
> > This patch removes the use of stop_machine() in try_offline_node() and
> > adds comments to try_offline_node() and remove_memory() that
> > lock_device_hotplug() is required.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> 
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Thanks!
-Toshi


