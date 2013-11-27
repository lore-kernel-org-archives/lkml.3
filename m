Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3K0EeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 23:34:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43130 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3K0EeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 23:34:04 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-64-52957638e463
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@rjwysocki.net>, "'Tejun Heo'" <tj@kernel.org>
Cc: "'Mika Westerberg'" <mika.westerberg@linux.intel.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        "'James E.J. Bottomley'" <JBottomley@parallels.com>,
        linux-ide@vger.kernel.org, "'Linux PCI'" <linux-pci@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
 <3805095.rqdZNnA0Ng@vostro.rjw.lan> <20131125101154.GS2281@intel.com>
 <9509557.LMLHG8ie3T@vostro.rjw.lan>
In-reply-to: <9509557.LMLHG8ie3T@vostro.rjw.lan>
Subject: Re: [PATCH] ATA: Fix port removal ordering
Date: Wed, 27 Nov 2013 13:34:00 +0900
Message-id: <000001ceeb29$e4d27f70$ae777e50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7p1r8tcENps/zyRQare1IkWhPFcABUr5Mw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zY12LsqlBBos+W1ksacqwaF68ns3i
	Uu8SVovLCy+xWhzb8YjJ4vKuOWwWZ+cdZ7OYsv0Iu8WZ00CJX8uPMjpweSzYVOqxaVUnm8e8
	k4Ee++euYfc4Oe8nm8eWq+0sHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+XwJXxo2EfU8Et1Yr/
	3dsZGxi/yncxcnJICJhINDzYxwphi0lcuLeerYuRi0NIYBmjxO5dnWwwRd/XX2GHSExnlDjb
	egosISTwi1Hi55NiEJtNQE3iy5fD7CC2iICXxNHWOWANzALXmCQ+9N5ghejeyyhx4M4yRpAq
	TgEDicV3O8F2CwsYS1x4cQSsm0VAVWLZrZtgNbwCthItzXfZIGxBiR+T77F0MXIATVWXmDIl
	FyTMLCAvsXnNW2aQsARQ+NFfXYgbjCRaD19nhygRkdj34h0jxDMzOSQeHvaE2CQg8W3yIRaI
	VlmJTQeYIUokJQ6uuMEygVFiFpK9sxD2zkKydxaSBQsYWVYxiqYWJBcUJ6UXGeoVJ+YWl+al
	6yXn525ihER87w7G2wesDzEmA22fyCwlmpwPTBh5JfGGxmZGFqYmpsZG5pZmpAkrifMmPUwK
	EhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDoUWRUbsZ50vTbjEmeexetidu0X/nLgYhjL98v
	esc40erC/gS+WU9fTQ13/P350rfKP2+vdxp8dVwxt8H20+ZfwnOSjjrLLlsfKqVvzGV7vy/g
	+k2bQqnJkb4zC+fZ/bS8wL9yntIrf+0Pyg7nk0N3zj0nfOI9U0mIxFOpI1IX4mrmGBnbxPbK
	KLEUZyQaajEXFScCAFpUI4YOAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jQV2LsqlBBqsOmVosacqwaF68ns3i
	Uu8SVovLCy+xWhzb8YjJ4vKuOWwWZ+cdZ7OYsv0Iu8WZ00CJX8uPMjpweSzYVOqxaVUnm8e8
	k4Ee++euYfc4Oe8nm8eWq+0sHn1bVjF6fN4kF8AR1cBok5GamJJapJCal5yfkpmXbqvkHRzv
	HG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0opJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd
	35AguB4jAzSQsI4x40fDPqaCW6oV/7u3MzYwfpXvYuTkkBAwkfi+/go7hC0mceHeerYuRi4O
	IYHpjBJnW0+xgSSEBH4xSvx8UgxiswmoSXz5chisQUTAS+Jo6xx2kAZmgWtMEh96b7BCdO9l
	lDhwZxkjSBWngIHE4rudrCC2sICxxIUXR8C6WQRUJZbduglWwytgK9HSfJcNwhaU+DH5HksX
	IwfQVHWJKVNyQcLMAvISm9e8ZQYJSwCFH/3VhbjBSKL18HV2iBIRiX0v3jFOYBSahWTQLIRB
	s5AMmoWkYwEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4ITyTGoH48oGi0OMAhyMSjy8
	Ey5PCRJiTSwrrsw9xCjBwawkwvspf2qQEG9KYmVValF+fFFpTmrxIcZkoDcnMkuJJucDk11e
	SbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAeNPN5fDRAu/n4
	TfXa3Giv2Jw9XOdW+bZvSzWKdcxz/HFfqX+x4bkGk5C0I9HFYu/kK9neqYoZXqioDvnt+n3J
	r47/orWyk9UkDnEk76///sSl7dgXqU61h6YP6vdbHOPhKD8QMNMoxudZWrPc3e73M8XWu25w
	+/niS0XwCq6L6WL3Xj8ofanEUpyRaKjFXFScCAA0NsgKbAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 25, 2013 9:19 PM, Rafael J. Wysocki wrote:
> 
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit bcdde7e221a8 (sysfs: make __sysfs_remove_dir() recursive)
> Mika Westerberg sees traces analogous to the one below in Thunderbolt
> hot-remove testing:
> 
>  WARNING: CPU: 0 PID: 4 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
>  sysfs group ffffffff81c6f1e0 not found for kobject 'host7'
>  Modules linked in:
>  CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 3.12.0+ #13
>  Hardware name:                  /D33217CK, BIOS GKPPT10H.86A.0042.2013.0422.1439 04/22/2013
>  Workqueue: kacpi_hotplug acpi_hotplug_work_fn
>   0000000000000009 ffff8801002459b0 ffffffff817daab1 ffff8801002459f8
>   ffff8801002459e8 ffffffff810436b8 0000000000000000 ffffffff81c6f1e0
>   ffff88006d440358 ffff88006d440188 ffff88006e8b4c28 ffff880100245a48
>  Call Trace:
>   [<ffffffff817daab1>] dump_stack+0x45/0x56
>   [<ffffffff810436b8>] warn_slowpath_common+0x78/0xa0
>   [<ffffffff81043727>] warn_slowpath_fmt+0x47/0x50
>   [<ffffffff811ad319>] ? sysfs_get_dirent_ns+0x49/0x70
>   [<ffffffff811ae526>] sysfs_remove_group+0xc6/0xd0
>   [<ffffffff81432f7e>] dpm_sysfs_remove+0x3e/0x50
>   [<ffffffff8142a0d0>] device_del+0x40/0x1b0
>   [<ffffffff8142a24d>] device_unregister+0xd/0x20
>   [<ffffffff8144131a>] scsi_remove_host+0xba/0x110
>   [<ffffffff8145f526>] ata_host_detach+0xc6/0x100
>   [<ffffffff8145f578>] ata_pci_remove_one+0x18/0x20
>   [<ffffffff812e8f48>] pci_device_remove+0x28/0x60
>   [<ffffffff8142d854>] __device_release_driver+0x64/0xd0
>   [<ffffffff8142d8de>] device_release_driver+0x1e/0x30
>   [<ffffffff8142d257>] bus_remove_device+0xf7/0x140
>   [<ffffffff8142a1b1>] device_del+0x121/0x1b0
>   [<ffffffff812e43d4>] pci_stop_bus_device+0x94/0xa0
>   [<ffffffff812e437b>] pci_stop_bus_device+0x3b/0xa0
>   [<ffffffff812e437b>] pci_stop_bus_device+0x3b/0xa0
>   [<ffffffff812e44dd>] pci_stop_and_remove_bus_device+0xd/0x20
>   [<ffffffff812fc743>] trim_stale_devices+0x73/0xe0
>   [<ffffffff812fc78b>] trim_stale_devices+0xbb/0xe0
>   [<ffffffff812fc78b>] trim_stale_devices+0xbb/0xe0
>   [<ffffffff812fcb6e>] acpiphp_check_bridge+0x7e/0xd0
>   [<ffffffff812fd90d>] hotplug_event+0xcd/0x160
>   [<ffffffff812fd9c5>] hotplug_event_work+0x25/0x60
>   [<ffffffff81316749>] acpi_hotplug_work_fn+0x17/0x22
>   [<ffffffff8105cf3a>] process_one_work+0x17a/0x430
>   [<ffffffff8105db29>] worker_thread+0x119/0x390
>   [<ffffffff8105da10>] ? manage_workers.isra.25+0x2a0/0x2a0
>   [<ffffffff81063a5d>] kthread+0xcd/0xf0
>   [<ffffffff81063990>] ? kthread_create_on_node+0x180/0x180
>   [<ffffffff817eb33c>] ret_from_fork+0x7c/0xb0
>   [<ffffffff81063990>] ? kthread_create_on_node+0x180/0x180
> 
> The source of this problem is that SCSI hosts are removed from
> ATA ports after calling ata_tport_delete() which removes the
> port's sysfs directory, among other things.  Now, after commit
> bcdde7e221a8, the sysfs directory is removed along with all of
> its subdirectories that include the SCSI host's sysfs directory
> and its subdirectories at this point.  Consequently, when
> device_del() is finally called for any child device of the SCSI
> host and tries to remove its "power" group (which is already
> gone then), it triggers the above warning.
> 
> To make the warnings go away, change the removal ordering in
> ata_port_detach() so that the SCSI host is removed from the
> port before ata_tport_delete() is called.
> 
> References: https://bugzilla.kernel.org/show_bug.cgi?id=65281
> Reported-and-tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Tested-by: Jingoo Han <jg1.han@samsung.com>

I tested this patch on Exynos platform with PCI-SATA card.
I checked that the kernel panic is resolved.
Thank you.

Best regards,
Jingoo Han

> ---
> 
> Hi,
> 
> This along with https://patchwork.kernel.org/patch/3226081/ makes
> all of the warnings observed by Mika go away without the patch at
> https://patchwork.kernel.org/patch/3201841/ applied.
> 
> Thanks,
> Rafael
> 
> ---
>  drivers/ata/libata-core.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-pm/drivers/ata/libata-core.c
> ===================================================================
> --- linux-pm.orig/drivers/ata/libata-core.c
> +++ linux-pm/drivers/ata/libata-core.c
> @@ -6304,10 +6304,9 @@ static void ata_port_detach(struct ata_p
>  		for (i = 0; i < SATA_PMP_MAX_PORTS; i++)
>  			ata_tlink_delete(&ap->pmp_link[i]);
>  	}
> -	ata_tport_delete(ap);
> -
>  	/* remove the associated SCSI host */
>  	scsi_remove_host(ap->scsi_host);
> +	ata_tport_delete(ap);
>  }
> 
>  /**
> 
> --

