Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab3K1AlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 19:41:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15550 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3K1AlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 19:41:10 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-72-5296912414c3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@rjwysocki.net>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Tejun Heo'" <tj@kernel.org>,
        "'Mika Westerberg'" <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "'Linux PCI'" <linux-pci@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
 <4668705.kv8hgxjqAc@vostro.rjw.lan> <20131123230701.GA6183@kroah.com>
 <53283503.VcSP9RLiFc@vostro.rjw.lan>
 <CAErSpo7LOVoSzOO1DbAhU6naq8YXKEd4A=Ls7DbaEt9jX8SBDg@mail.gmail.com>
In-reply-to: <CAErSpo7LOVoSzOO1DbAhU6naq8YXKEd4A=Ls7DbaEt9jX8SBDg@mail.gmail.com>
Subject: Re: [PATCH] PCI: Move device_del() from pci_stop_dev() to
 pci_destroy_dev()
Date: Thu, 28 Nov 2013 09:41:08 +0900
Message-id: <000101ceebd2$872e48a0$958ad9e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7qKbWAyDaFu4m7THSJsn7QUQHQywBp9ukA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zQ12VidOCDJ48UbdY0pRh0bx4PZvF
	5YWXWC0u75rDZnF23nE2iynbj7BbnDkNFPu1/CijA4fHgk2lHptWdbJ5zDsZ6LF/7hp2jy1X
	21k8+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK+Pprh1sBbe1K3bu+cXawNii2sXIySEhYCLR
	/eQJI4QtJnHh3nq2LkYuDiGBZYwSf3rus8IU7Z91jh3EFhKYziix8Kg3hP2LUaLjThGIzSag
	JvHly2GwGhEBXYmue7NYQAYxCyxmkmh6cZcdYmork8Tjr81sIFWcAsESqzccZgKxhQXCJN4u
	Pg20jYODRUBVYmmXH0iYV8BWovXdLRYIW1Dix+R7YDazgJbE+p3HmSBseYnNa94yg7RKCKhL
	PPqrC2KKCBhJnGiKhagQkdj34h3Uj3/ZJf41xIDYLAICEt8mH2KB6JSV2HSAGaJEUuLgihss
	ExglZiHZOwvJ3llI9s5CsmEBI8sqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJCI7tvBePOA
	9SHGZKD1E5mlRJPzgQkhryTe0NjMyMLUxNTYyNzSjDRhJXHeRQ+TgoQE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwBnerJG/92+mgoPZdZI5qyyG5JfpcPnz5l+0cX9z1XmW/K+lhnMKz3o37
	HbSfZrt2vZ2e8iSg6pD0nC1aLzbcCDqX6frg+dcO6+Dnzeuse2Yf11kWK3PU5rLOQY29b/w+
	Wvi1/vHM5mn8nvrE9Yr6ysiP7AEpaT0uujxBTW9Wz5nyY7aYWcE1JZbijERDLeai4kQAjVoY
	5P4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jQV2VidOCDFbsU7JY0pRh0bx4PZvF
	5YWXWC0u75rDZnF23nE2iynbj7BbnDkNFPu1/CijA4fHgk2lHptWdbJ5zDsZ6LF/7hp2jy1X
	21k8+rasYvT4vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB+gmJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPG0107
	2Apua1fs3POLtYGxRbWLkZNDQsBEYv+sc+wQtpjEhXvr2UBsIYHpjBILj3pD2L8YJTruFIHY
	bAJqEl++HAarFxHQlei6N4uli5GLg1lgMZNE04u77CCOkEArk8Tjr81gkzgFgiVWbzjMBGIL
	C4RJvF18mrWLkYODRUBVYmmXH0iYV8BWovXdLRYIW1Dix+R7YDazgJbE+p3HmSBseYnNa94y
	g7RKCKhLPPqrC2KKCBhJnGiKhagQkdj34h3jBEahWUgGzUIyaBaSQbOQtCxgZFnFKJpakFxQ
	nJSea6hXnJhbXJqXrpecn7uJEZwwnkntYFzZYHGIUYCDUYmHV0JnWpAQa2JZcWXuIUYJDmYl
	EV6FYqAQb0piZVVqUX58UWlOavEhxmSgNycyS4km5wOTWV5JvKGxiZmRpZGZhZGJuTlpwkri
	vAdarQOFBNITS1KzU1MLUotgtjBxcEo1MKo3l3Ua/vqZavbSwN9n+YHKS2JXEt8W/QrdoLK7
	evP2vNLCpIQExcqSS1WePhechOu0E29cTT2SsPrqyoAyxTlPal/c6ms5+zXA3Ed+Hn/adrNK
	oy2a6RPL0g4/cer+efZQzidXRc4PO49NKTn/89Eqnt3nRE05ZtwJ+zKZozs1t9FrS038QyWW
	4oxEQy3mouJEAIMF2WFcAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 26, 2013 7:00 AM, Bjorn Helgaas wrote:
> On Sat, Nov 23, 2013 at 5:17 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > After commit bcdde7e221a8 (sysfs: make __sysfs_remove_dir() recursive)
> > I'm seeing traces analogous to the one below in Thunderbolt testing:
> >
> > WARNING: CPU: 3 PID: 76 at /scratch/rafael/work/linux-pm/fs/sysfs/group.c:214
> sysfs_remove_group+0x59/0xe0()
> >  sysfs group ffffffff81c6c500 not found for kobject '0000:08'
> >  Modules linked in: fuse hidp af_packet xt_tcpudp xt_pkttype xt_LOG xt_limit ip6t_REJECT
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter
> ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4
> ip_tables xt_conntrack nf_conntrack rfcomm ip6table_filter bnep ip6_tables x_tables arc4 ath9k
> mac80211 x86_pkg_temp_thermal intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul iTCO_wdt
> crc32c_intel iTCO_vendor_support ghash_clmulni_intel aesni_intel ablk_helper acer_wmi sparse_keymap
> ath9k_common ath9k_hw cryptd lrw gf128mul ath3k glue_helper aes_x86_64 btusb microcode ath pcspkr
> joydev uvcvideo serio_raw videobuf2_core i2c_i801 videodev snd_hda_codec_hdmi cfg80211
> videobuf2_vmalloc tg3 videobuf2_memops sg ptp pps_core lpc_ich mfd_core snd_hda_codec_realtek
> bluetooth hid_logitech_dj rfkill snd_hda_intel snd_hda_codec shpchp battery ac wmi acpi_cpufreq edd
> snd_usb_audio snd_pcm snd_page_alloc snd_hwdep
>  snd_usbmidi_lib
> > snd_rawmidi snd_seq snd_timer snd_seq_device snd soundcore autofs4 xhci_hcd processor scsi_dh_hp_sw
> scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_dh
> >  CPU: 3 PID: 76 Comm: kworker/u16:7 Not tainted 3.13.0-rc1+ #76
> >  Hardware name: Acer Aspire S5-391/Venus    , BIOS V1.02 05/29/2012
> >  Workqueue: kacpi_hotplug acpi_hotplug_work_fn
> >   0000000000000009 ffff8801644b9ac8 ffffffff816b23bf 0000000000000007
> >   ffff8801644b9b18 ffff8801644b9b08 ffffffff81046607 ffff88016925b800
> >   0000000000000000 ffffffff81c6c500 ffff88016924f928 ffff88016924f800
> >  Call Trace:
> >   [<ffffffff816b23bf>] dump_stack+0x4e/0x71
> >   [<ffffffff81046607>] warn_slowpath_common+0x87/0xb0
> >   [<ffffffff810466d1>] warn_slowpath_fmt+0x41/0x50
> >   [<ffffffff811e42ef>] ? sysfs_get_dirent_ns+0x6f/0x80
> >   [<ffffffff811e5389>] sysfs_remove_group+0x59/0xe0
> >   [<ffffffff8149f00b>] dpm_sysfs_remove+0x3b/0x50
> >   [<ffffffff81495818>] device_del+0x58/0x1c0
> >   [<ffffffff814959c8>] device_unregister+0x48/0x60
> >   [<ffffffff813254fe>] pci_remove_bus+0x6e/0x80
> >   [<ffffffff81325548>] pci_remove_bus_device+0x38/0x110
> >   [<ffffffff8132555d>] pci_remove_bus_device+0x4d/0x110
> >   [<ffffffff81325639>] pci_stop_and_remove_bus_device+0x19/0x20
> >   [<ffffffff813418d0>] disable_slot+0x20/0xe0
> >   [<ffffffff81341a38>] acpiphp_check_bridge+0xa8/0xd0
> >   [<ffffffff813427ad>] hotplug_event+0x17d/0x220
> >   [<ffffffff81342880>] hotplug_event_work+0x30/0x70
> >   [<ffffffff8136d665>] acpi_hotplug_work_fn+0x18/0x24
> >   [<ffffffff81061331>] process_one_work+0x261/0x450
> >   [<ffffffff81061a7e>] worker_thread+0x21e/0x370
> >   [<ffffffff81061860>] ? rescuer_thread+0x300/0x300
> >   [<ffffffff81068342>] kthread+0xd2/0xe0
> >   [<ffffffff81068270>] ? flush_kthread_worker+0x70/0x70
> >   [<ffffffff816c19bc>] ret_from_fork+0x7c/0xb0
> >   [<ffffffff81068270>] ? flush_kthread_worker+0x70/0x70
> >
> > (Mika Westerberg sees them too in his tests).
> >
> > Some investigation documented in kernel bug #65281 lead me to the
> > conclusion that the source of the problem is the device_del() in
> > pci_stop_dev() as it now causes the sysfs directory of the device
> > to be removed recursively along with all of its subdirectories.
> > That includes the sysfs directory of the device's subordinate
> > bus (dev->subordinate) and its "power" group.
> >
> > Consequently, when pci_remove_bus() is called for dev->subordinate
> > in pci_remove_bus_device(), it calls device_unregister(&bus->dev),
> > but at this point the sysfs directory of bus->dev doesn't exist any
> > more and its "power" group doesn't exist either.  Thus, when
> > dpm_sysfs_remove() called from device_del() tries to remove that
> > group, it triggers the above warning.
> >
> > That indicates a logical mistake in the design of
> > pci_stop_and_remove_bus_device(), which causes bus device objects
> > to be left behind their parents (bridge device objects) and can be
> > fixed by moving the device_del() from pci_stop_dev() into
> > pci_destroy_dev(), so pci_remove_bus() can be called for the
> > device's subordinate bus before the device itself is unregistered
> > from the hierarchy.  Still, the driver, if any, should be detached
> > from the device in pci_stop_dev(), so use device_release_driver()
> > directly from there.
> >
> > References: https://bugzilla.kernel.org/show_bug.cgi?id=65281#c6
> > Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Applied to for-linus for v3.13.  Thanks a lot for all your work on this issue!

Hi Rafael J. Wysocki,

A week ago, I found this warning when removing PCI devices.
However, I was not able to fix this warning.

Today, I tested your patch on Samsung Exynos platform
with PCI-LAN card. I checked that this warning is resolved.
I really appreciate you patch! :-)
Thank you.

Best regards,
Jingoo Han

