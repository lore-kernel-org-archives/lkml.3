Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaJHUTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:19:21 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:59336 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaJHUTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:19:19 -0400
Date: Wed, 8 Oct 2014 22:19:06 +0200
From: Marc Burkhardt <marc@osknowledge.org>
To: linux-kernel@vger.kernel.org
Subject: WARNING: CPU: 0 PID: 3666 at net/wireless/reg.c:1806
 reg_process_hint+0x3b0/0x3c0 [cfg80211]()
Message-ID: <20141008201905.GA6904@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux marc 3.17.0-desper
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

just upgraded a box (that has no CRD agent installed) from a 3.10 kernel to the
just released 3.17 kernel an noticed the following when connecting to a HTC One
device:

[59168.564525] cfg80211: Calling CRDA for country: DE
[59169.263781] ------------[ cut here ]------------
[59169.263812] WARNING: CPU: 0 PID: 3666 at net/wireless/reg.c:1806 reg_process_hint+0x3b0/0x3c0 [cfg80211]()
[59169.263815] Modules linked in: ctr ccm sdhci_pci sdhci mmc_core ehci_pci ehci_hcd acpi_power_meter acpi_pad fuse tp_smapi(O) nf_log_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 nf_log_ipv6 nf_log_common xt_LOG xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack af_packet dm_mod ip6table_filter ip6_tables iptable_filter joydev ip_tables x_tables hdaps(O) thinkpad_ec(O) msr ipv6 usbhid btusb bluetooth iwldvm mac80211 nvidia(PO) snd_hda_codec_conexant snd_hda_codec_generic usbcore mxm_wmi coretemp iwlwifi snd_hda_intel snd_hda_controller snd_hda_codec kvm_intel cfg80211 battery snd_hwdep snd_pcm kvm thinkpad_acpi snd_timer snd lpc_ich crc32_pclmul crc32c_intel thermal ac evdev rtc_cmos mfd_core i2c_i801 usb_common 8250 acpi_cpufreq wmi serial_core button soundcore processor [last unloaded: microcode]

[59169.263877] CPU: 0 PID: 3666 Comm: kworker/0:2 Tainted: P        W  O   3.17.0-desper #1
[59169.263879] Hardware name: LENOVO 43495KG/43495KG, BIOS 6MET92WW (1.52 ) 09/26/2012
[59169.263890] Workqueue: events reg_todo [cfg80211]
[59169.263893]  00000009 c138d40c 00000000 c1035c79 c14ba460 00000000 00000e52 e2f8196e
[59169.263899]  0000070e e2f62900 e2f62900 d01d2640 d9224140 d01d2654 dafc4100 c1035d2b
[59169.263904]  00000009 00000000 e2f62900 00000000 daa11900 c15af000 6811e7b4 000035d0
[59169.263910] Call Trace:
[59169.263919]  [<c138d40c>] ? dump_stack+0x45/0x65
[59169.263926]  [<c1035c79>] ? warn_slowpath_common+0x79/0x90
[59169.263938]  [<e2f62900>] ? reg_process_hint+0x3b0/0x3c0 [cfg80211]
[59169.263948]  [<e2f62900>] ? reg_process_hint+0x3b0/0x3c0 [cfg80211]
[59169.263952]  [<c1035d2b>] ? warn_slowpath_null+0x1b/0x20
[59169.263963]  [<e2f62900>] ? reg_process_hint+0x3b0/0x3c0 [cfg80211]
[59169.263974]  [<e2f6296a>] ? reg_todo+0x5a/0x170 [cfg80211]
[59169.263979]  [<c1047ebc>] ? process_one_work+0xec/0x2b0
[59169.263984]  [<c10798fe>] ? internal_add_timer+0x1e/0x70
[59169.263987]  [<c1079e8c>] ? mod_timer+0xbc/0x130
[59169.263990]  [<c104865c>] ? worker_thread+0xec/0x400
[59169.263994]  [<c1048570>] ? cancel_delayed_work_sync+0x10/0x10
[59169.263998]  [<c104bec8>] ? kthread+0x98/0xb0
[59169.264002]  [<c1391c01>] ? ret_from_kernel_thread+0x21/0x30
[59169.264006]  [<c104be30>] ? kthread_create_on_node+0x110/0x110
[59169.264009] ---[ end trace ab379192b30946cf ]---
[59169.264012] cfg80211: Calling CRDA for country: DE

The kernel is tainted, yes. But maybe someone could take a look.

Thanks,
Marc

-- 
Marc Burkhardt
