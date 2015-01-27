Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbbA0Ouy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:50:54 -0500
Received: from mail-by2on0134.outbound.protection.outlook.com ([207.46.100.134]:35879
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758262AbbA0Ouv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:50:51 -0500
X-Greylist: delayed 943 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2015 09:50:51 EST
From: Stuart Yoder <stuart.yoder@freescale.com>
To: "arnd@arndb.de" <arnd@arndb.de>, "agraf@suse.de" <agraf@suse.de>
CC: Jose Rivera <German.Rivera@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH 0/3 v6] drivers/bus: Freescale Management Complex bus
 driver patch series
Thread-Topic: [PATCH 0/3 v6] drivers/bus: Freescale Management Complex bus
 driver patch series
Thread-Index: AQHQMfGjrcNvsyPegk6kHUFBdNRjCpzUEwHA
Date: Tue, 27 Jan 2015 14:35:05 +0000
Message-ID: <CY1PR0301MB07489DAC1197846545E79F0587320@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1421456477-27041-1-git-send-email-German.Rivera@freescale.com>
In-Reply-To: <1421456477-27041-1-git-send-email-German.Rivera@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.168.50]
authentication-results: arndb.de; dkim=none (message not signed)
 header.d=none;arndb.de; dmarc=none action=none header.from=freescale.com;
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:CY1PR0301MB1305;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1305;
x-forefront-prvs: 046985391D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(164054003)(51704005)(377454003)(122556002)(40100003)(106116001)(2950100001)(2900100001)(33656002)(86362001)(99286002)(76576001)(62966003)(87936001)(50986999)(92566002)(54206007)(54606007)(2656002)(2501002)(74316001)(46102003)(102836002)(77156002)(66066001)(15975445007)(54356999)(19580395003)(19580405001)(76176999);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1305;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2015 14:35:05.2530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB1305
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1275;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd/Alex,

German has posted an example driver for the fsl-mc bus in his RFC
"[RFC PATCH 1/1] drivers/bus: fsl-mc object allocator driver".

In addition I have made available the skeleton for a driver for
one of the objects/devices (crypto) that will be discovered on
the bus:
    https://github.com/stuyoder/linux
    branch: fsl-ms-bus

...it is not functional yet, but shows how a driver registers with
the bus, get's probed, performs initialization.

Thanks,
Stuart


> -----Original Message-----
> From: J. German Rivera [mailto:German.Rivera@freescale.com]
> Sent: Friday, January 16, 2015 7:01 PM
> To: gregkh@linuxfoundation.org; arnd@arndb.de; linux-kernel@vger.kernel.org
> Cc: Yoder Stuart-B08248; Phillips Kim-R1AAHA; Wood Scott-B07421; agraf@suse.de; Hamciuc Bogdan-BHAMCIU1;
> Marginean Alexandru-R89243; Thorpe Geoff-R01361; Sharma Bhupesh-B45370; Erez Nir-RM30794; Schmitt Richard-
> B43082
> Subject: [PATCH 0/3 v6] drivers/bus: Freescale Management Complex bus driver patch series
> 
> This patch series introduces Linux support for the Freescale
> Management Complex (fsl-mc) hardware. This patch series is dependent
> on the patch series "ARM64: Add support for FSL's LS2085A SoC"
> (http://thread.gmane.org/gmane.linux.ports.arm.kernel/351829)
> 
> The fsl-mc is a hardware resource manager that manages specialized
> hardware objects used in network-oriented packet processing
> applications.  After the fsl-mc block is enabled, pools of hardware
> resources are available, such as queues, buffer pools, I/O
> interfaces.  These resources are building blocks that can be
> used to create functional hardware objects such as network
> interfaces, crypto accelerator instances, or L2 switches.
> 
> All the fsl-mc managed hardware resources/objects are represented in
> a physical grouping mechanism called a 'container' or DPRC (data
> path resource container).
> 
> From the point of view of an OS, a DPRC functions similar to a plug
> and play bus.  Using fsl-mc commands software can enumerate the
> contents of the DPRC discovering the hardware objects present
> and binding them to drivers.  Hardware objects can be created
> and removed dynamically, providing hot pluggability of the hardware
> objects.
> 
> Software contexts interact with the fsl-mc by sending commands through
> a memory mapped hardware interface called an "MC portal". Every
> fsl-mc object type has a command set to manage the objects. Key
> DPRC commands include:
>    -create/destroy a DPRC
>    -enumerate objects and resource pools in the DPRC, including
>     identifying mappable regions and the number of IRQs an object
>     may have
>    -IRQ configuration
>    -move objects/resources between DPRCs
>    -connecting objects (e.g. connecting a network interface to
>     an L2 switch port)
>    -reset
> 
> Patch 1 contains a minimal set of low level functions to send an
> d receive commands to the fsl-mc. It includes support for basic
> management commands and commands to manipulate DPRC objects.
> 
> Patch 2 contains a platform device driver that sets up and registers
> the basic bus infrastructure including support for adding/removing
> devices, register/unregister of drivers, and bus match support
> to bind devices to drivers.
> 
> Patch 3 contains an driver that manages DPRC objects (the
> container that holds the hardware resources). This driver
> functions as a bus controller and handles enumeration
> of the objects in the container and hotplug events.
> 
> CHANGE HISTORY
> 
> Changes in v6:
> - Upgraded MC flibs to version 0.5
> - Fixed warnings from latest checkpatch
> 
> Changes in v5:
> - Addressed comments from Alex Graf. Details in each patch.
> 
> Changes in v4:
> - Addressed changes from ALex Graf. Details in each patch.
> - Upgraded MC flibs to version 0.5
> - Fixed bug related to setting fsl_mc_bus_type.dev_root too late
> 
> Changes in v3:
> - Addressed pending issues not resolved in v2:
>   * Removed Doxygen comments as requested by Greg Kroah-Hartman
>   * Moved newly added FSL-specific header files from include/linux to
>     include/linux/fsl
>   * Changed wording of licenses in MC flib source files
>   * Fixed sparse warning about context imbalance in 'mc_send_command'
> 
> - Addressed additional comments from Kim Phillips, Scott Wood and
>   Timur Tabi. Details in each patch.
> 
> Issues pending resolution not addressed by v3:
> - Checkpatch warnings:
>   * WARNING: DT compatible string "fsl,qoriq-mc" appears un-documented
>     This warning will go away once the prerequisite patch series is
>     accepted upstream.
>   * WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
>     This warning still happens even after adding MAINTAINERS file entries in
>     the same patch where new files were added
> 
> Changes in v2:
> - Added reference to the patch series this patch is dependent on for
>   device tree and device tree bindings changes. (See above).
> - Removed patch 4 (update to the MAINTAINERS file), as this is done
>   now in patch 1
> - Addressed comments from Joe Perches, Kim Phillips, Alex Graf
>   and Scott Wood. Details in each patch.
> 
> Issues pending resolution not addressed by v2:
> - What to do with Doxygen comments in patch 1
> - Whether to move or not FSL-specific header files added in include/linux,
>   by this patch series, to another location
> - Whether to change or not the wording of the licenses used in some
>   source files
> - Checkpatch warnings:
>   * WARNING: DT compatible string "fsl,qoriq-mc" appears un-documented
>     This warning will go away once the prerequisite patch series is
>     accepted upstream.
>   * WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
>     This warning still happens even after adding MAINTAINERS file entries in
>     the same patch where new files were added
> - Sparse warning:
>   * drivers/bus/fsl-mc/fsl_mc_sys.c:193:9: warning: context imbalance in 'mc_send_command' - different lock
> contexts for basic block
>     This warning is caused by conditionally acquiring/releasing a lock in function mc_send_command().
>     Not clear how to solve this warning, as we need to be able to decide at
>     run time based on a flag whether to acquire the lock or not.
> 
> Changes in v1:
> - No changes since RFC v4
> 
> Changes in RFC v4:
> - Fixed parameter mismatch for device_find_child() call in fsl_mc_dprc.c
> - Added back the dma_mask field to struct fsl_mc_device as it is needed
>   by some MC child device drivers. However, the default DMA mask now
>   does not have the 32-bit limitation of the original patch series (v1).
> 
> Changes in RFC v3:
> Rework to address comments from Arnd Bergmann:
> - Removed per-bus list of children, and instead use device_for_each_child()
> - Use the same structure (struct fsl_mc_device) to represent both
>   bus devices and their children.
> http://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg711301.html
> 
> Changes in RFC v2:
> Rework to address comments from Arnd Bergmann:
> - Removed fsl_mc_bus structure and global variable
> - Removed the 'magic' fields from all structs
> - Removed NULL initializers
> - Replaced all occurrences of EXPORT_SYMBOL() with EXPORT_SYMBOL_GPL()
> - Removed function dprc_parse_dt_node(), and replaced its call by a
>   direct call to of_address_to_resource()
> - Removed struct fsl_mc_device_region and use standard 'struct resource'
>   instead.
> - Removed dma_mask field from 'struct fsl_mc_device' as it is not currently
>   being used.
> - Removed redundant 'driver' field from struct fsl_mc_device
> - Removed the container field. We can get the parent DPRC of a given dev,
>   from its dev.parent field.
> http://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg708858.html

