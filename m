Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab3LHTWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 14:22:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab3LHTWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 14:22:16 -0500
Message-ID: <52A4C6D2.3020208@redhat.com>
Date: Sun, 08 Dec 2013 20:21:54 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        LKML <linux-kernel@vger.kernel.org>, viresh.kumar@linaro.org,
        tianyu.lan@intel.com, jinchoi@broadcom.com
Subject: Re: Regression with suspend resume 5a87182aa21d6d5d306840feab9321818dd3e2a3
References: <52A448F2.4010208@redhat.com> <1386501189.28599.5.camel@x220.thuisdomein>
In-Reply-To: <1386501189.28599.5.camel@x220.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 8.12.2013 12:13, Paul Bolle napsal(a):
> On Sun, 2013-12-08 at 11:24 +0100, Zdenek Kabelac wrote:
>> I'm testing recent 3.13-rc kernel - and I've notice my Lenovo T61 is not able
>> to resume.  After bisect I've found commit:
>>
>> 5a87182aa21d6d5d306840feab9321818dd3e2a3
>
> That's "cpufreq: suspend governors on system suspend/hibernate".
>
>> When I just revert this commit with 374b105797c3d4f29c685f3be535c35f5689b30e
>> (3.13-rc3)   suspend/resume works again.
>> (I'm using  ondemand CPU governor)
>
> Rafael just asked Linus to pull a revert of that commit (see
> https://lkml.org/lkml/2013/12/7/126 ).
>
>


I'm not sure - but it also could be related with another warning I'm getting
during resume:

But possibly this is result in  i915 update ?

Zdenek


PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.005 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2042 at drivers/gpu/drm/i915/intel_display.c:9948 
intel_get_pipe_from_connector+0x49/0x50 [i915]()
Modules linked in: i915 i2c_algo_bit drm_kms_helper drm ctr ccm ipt_MASQUERADE 
iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack 
nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp tun bridge stp 
llc ipv6 ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables 
bnep btusb bluetooth snd_hda_codec_analog iTCO_wdt iTCO_vendor_support arc4 
coretemp kvm_intel kvm microcode iwl3945 iwlegacy psmouse serio_raw mac80211 
i2c_i801 i2c_core sdhci_pci r852 sm_common sdhci nand cfg80211 nand_ecc 
snd_hda_intel nand_ids mmc_core mtd snd_hda_codec r592 snd_hwdep snd_seq 
memstick snd_seq_device snd_pcm lpc_ich mfd_core e1000e snd_page_alloc 
snd_timer ptp pps_core thinkpad_acpi wmi nvram snd soundcore evdev binfmt_misc 
nfsd auth_rpcgss oid_registry exportfs loop nfs_acl lockd sunrpc pcmcia sr_mod 
yenta_socket cdrom ehci_pci ehci_hcd uhci_hcd usbcore usb_common video 
backlight autofs4
CPU: 0 PID: 2042 Comm: kworker/u4:3 Tainted: G        W 
3.13.0-rc3-00006-gee4645c #186
Hardware name: LENOVO 6464CTO/6464CTO, BIOS 7LETC9WW (2.29 ) 03/18/2011
Workqueue: events_unbound async_run_entry_fn
  0000000000000009 ffff88009ad21af8 ffffffff815a3bfe 0000000000000000
  ffff88009ad21b30 ffffffff8104924d ffff8800b5f4fe00 ffff8800aa408000
  ffffffffffffffff ffff8800b5f4fe00 ffff8800b5f4fe00 ffff88009ad21b40
Call Trace:
  [<ffffffff815a3bfe>] dump_stack+0x4e/0x7a
  [<ffffffff8104924d>] warn_slowpath_common+0x7d/0xa0
  [<ffffffff8104932a>] warn_slowpath_null+0x1a/0x20
  [<ffffffffa0c27f59>] intel_get_pipe_from_connector+0x49/0x50 [i915]
  [<ffffffffa0c41e05>] intel_panel_disable_backlight+0x25/0x180 [i915]
  [<ffffffffa0c2cfad>] intel_disable_lvds+0x4d/0x180 [i915]
  [<ffffffffa0c1ceda>] i9xx_crtc_disable+0x28a/0x380 [i915]
  [<ffffffffa0be50ca>] i915_drm_freeze+0xca/0x150 [i915]
  [<ffffffffa0be54cd>] i915_pm_suspend+0x3d/0x90 [i915]
  [<ffffffff813668bc>] pci_pm_suspend+0x6c/0x150
  [<ffffffff81366850>] ? pci_pm_freeze+0xe0/0xe0
  [<ffffffff81433e89>] dpm_run_callback+0x49/0xa0
  [<ffffffff8143428d>] __device_suspend+0xdd/0x280
  [<ffffffff8143444f>] async_suspend+0x1f/0xa0
  [<ffffffff81079e87>] async_run_entry_fn+0x37/0x130
  [<ffffffff8106a8ed>] process_one_work+0x1fd/0x6d0
  [<ffffffff8106a88b>] ? process_one_work+0x19b/0x6d0
  [<ffffffff8106aee1>] worker_thread+0x121/0x3a0
  [<ffffffff8106adc0>] ? process_one_work+0x6d0/0x6d0
  [<ffffffff81072fc0>] kthread+0xf0/0x110
  [<ffffffff81072ed0>] ? insert_kthread_work+0x70/0x70
  [<ffffffff815b402c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81072ed0>] ? insert_kthread_work+0x70/0x70
---[ end trace 7517bdfd550790cc ]---
PM: suspend of devices complete after 797.599 msecs
PM: late suspend of devices complete after 3.960 msecs

