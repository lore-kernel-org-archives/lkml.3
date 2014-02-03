Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaBCUEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:04:46 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42303 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBCUEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:04:44 -0500
Message-ID: <52EFF658.2080001@lwfinger.net>
Date: Mon, 03 Feb 2014 14:04:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Kernel WARNING splat in 3.14-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my freshly built 3.14-rc1 kernel, I get the following new warning splat from 
slub:

[   69.008845] ------------[ cut here ]------------
[   69.008861] WARNING: CPU: 0 PID: 1578 at mm/slub.c:1007 
deactivate_slab+0x4bb/0x520()
[   69.008863] Modules linked in: rfcomm nfs fscache af_packet lockd sunrpc bnep 
rtl8723be arc4 rtl8723_common b43 rtl_pci rtlwifi mac80211 cfg80211 btusb bl
uetooth powernow_k8 kvm_amd kvm snd_hda_intel snd_hda_codec bcma snd_hwdep r852 
sdhci_pci sdhci snd_pcm sr_mod snd_seq ssb cdrom forcedeth sm_common pcspkr s
nd_timer serio_raw snd_seq_device snd nand mtd mmc_core rfkill ata_generic 
pata_amd nand_ids nand_bch bch nand_ecc 6lowpan_iphc soundcore btcoexist r592 ac v
ideo memstick button battery sg dm_mod autofs4 thermal processor thermal_sys hwmon
[   69.008934] CPU: 0 PID: 1578 Comm: akonadi_newmail Not tainted 3.14.0-rc1-wl+ #60
[   69.008936] Hardware name: Hewlett-Packard HP Pavilion dv2700 Notebook 
PC/30D6, BIOS F.27 11/27/2008
[   69.008939]  0000000000000009 ffff880085ab1cd0 ffffffff815ee4a0 0000000000000000
[   69.008945]  ffff880085ab1d08 ffffffff8104e768 ffffea0001ee69c0 ffff8800bb401800
[   69.008950]  0000000000000000 ffff8800bb400c80 0000000000000002 ffff880085ab1d18
[   69.008956] Call Trace:
[   69.008965]  [<ffffffff815ee4a0>] dump_stack+0x4d/0x6f
[   69.008971]  [<ffffffff8104e768>] warn_slowpath_common+0x78/0xa0
[   69.008976]  [<ffffffff8104e845>] warn_slowpath_null+0x15/0x20
[   69.008980]  [<ffffffff8118581b>] deactivate_slab+0x4bb/0x520
[   69.008985]  [<ffffffff81183429>] ? new_slab+0x1f9/0x300
[   69.008989]  [<ffffffff815ebe57>] __slab_alloc+0x34d/0x4f5
[   69.008994]  [<ffffffff81185a6b>] ? kmem_cache_alloc+0x18b/0x1c0
[   69.008999]  [<ffffffff810770d1>] ? prepare_creds+0x21/0x1a0
[   69.009003]  [<ffffffff810770d1>] ? prepare_creds+0x21/0x1a0
[   69.009007]  [<ffffffff81185a6b>] kmem_cache_alloc+0x18b/0x1c0
[   69.009011]  [<ffffffff810770d1>] prepare_creds+0x21/0x1a0
[   69.009016]  [<ffffffff8119f955>] SyS_access+0x35/0x1f0
[   69.009019]  [<ffffffff815fe8a2>] system_call_fastpath+0x16/0x1b
[   69.009019] ---[ end trace c63f75644bfb030a ]---

There is a similar warning for my other CPU as well. The warning comes from 
"lockdep_assert_held(&n->list_lock);".

If needed, I can bisect this issue.

Larry
