Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3HNXut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:50:49 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43214 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab3HNXur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:50:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave@sr71.net>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] drivers: base: dynamic memory block creation
Date: Thu, 15 Aug 2013 02:01:09 +0200
Message-ID: <5959614.447qgH8r7c@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1376508705-3188-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1376508705-3188-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 14, 2013 02:31:45 PM Seth Jennings wrote:
> Large memory systems (~1TB or more) experience boot delays on the order
> of minutes due to the initializing the memory configuration part of
> sysfs at /sys/devices/system/memory/.
> 
> ppc64 has a normal memory block size of 256M (however sometimes as low
> as 16M depending on the system LMB size), and (I think) x86 is 128M.  With
> 1TB of RAM and a 256M block size, that's 4k memory blocks with 20 sysfs
> entries per block that's around 80k items that need be created at boot
> time in sysfs.  Some systems go up to 16TB where the issue is even more
> severe.
> 
> This patch provides a means by which users can prevent the creation of
> the memory block attributes at boot time, yet still dynamically create
> them if they are needed.
> 
> This patch creates a new boot parameter, "largememory" that will prevent
> memory_dev_init() from creating all of the memory block sysfs attributes
> at boot time.  Instead, a new root attribute "show" will allow
> the dynamic creation of the memory block devices.
> Another new root attribute "present" shows the memory blocks present in
> the system; the valid inputs for the "show" attribute.

I wonder how this is going to work with the ACPI device object binding to
memory blocks that's in 3.11-rc.

That stuff will only work if the memory blocks are already there when
acpi_memory_enable_device() runs and that is called from the ACPI namespace
scanning code executed (1) during boot and (2) during hotplug.  So I don't
think you can just create them on the fly at run time as a result of a
sysfs write.

Thanks,
Rafael

