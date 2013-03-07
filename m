Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab3CGWSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:18:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933572Ab3CGWSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:18:39 -0500
Message-ID: <5139123D.8040901@redhat.com>
Date: Thu, 07 Mar 2013 23:18:37 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130222 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 prints warning
References: <5106867F.80309@redhat.com> <20130129130850.GC2306@redhat.com>
In-Reply-To: <20130129130850.GC2306@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 29.1.2013 14:08, Stanislaw Gruszka napsal(a):
> On Mon, Jan 28, 2013 at 03:09:03PM +0100, Zdenek Kabelac wrote:
>> I'm getting tthis warning printed with current 3.8-rc  kernel
>> My hw is Lenovo  T61.
>>
>>
>> [    5.920284] iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
>> [    5.976605] systemd[1]: Started NFS file locking service..
>> [    5.982624] NFSD: starting 90-second grace period (net ffffffff81aa08c0)
>> [    5.987930] ------------[ cut here ]------------
>> [    5.988026] WARNING: at lib/dma-debug.c:933 check_unmap+0x4ae/0x9a0()
>> [    5.988111] Hardware name: 6464CTO
>> [    5.988194] iwl3945 0000:03:00.0: DMA-API: device driver failed
>> to check map error[device address=0x00000000bb7a7800] [size=4096
>> bytes] [mapped as page]
>
> We have to check dma_map_*() error. Fixing all of calls to dma_map* in
> iwlegacy is not so simple. For now, you can just ignore this WARNING or
> disable CONFIG_DMA_API_DEBUG.
>


I've now tested  3.9-rc1  and it seems to be getting even worse.
(and 3.8 is not really good either)

iwl3945 0000:03:00.0: Error sending C_RXON: time out after 500ms.
iwl3945 0000:03:00.0: Error setting new configuration (-110).
------------[ cut here ]------------
WARNING: at lib/dma-debug.c:883 check_unmap+0xfb/0x9a0()
Hardware name: 6464CTO
iwl3945 0000:03:00.0: DMA-API: device driver frees DMA memory with different 
size [device address=0x00000000bb8e5000] [map size=80 bytes] [unmap size=21 bytes]
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT 
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge 
stp llc rfcomm bnep btusb bluetooth snd_hda_codec_analog arc4 iwl3945 iTCO_wdt 
iTCO_vendor_support iwlegacy mac80211 snd_hda_intel snd_hda_codec psmouse 
snd_seq serio_raw coretemp snd_seq_device microcode cfg80211 snd_pcm e1000e 
i2c_i801 r852 i2c_core sm_common nand ipv6 nand_ecc ptp nand_ids r592 mtd 
memstick snd_page_alloc ehci_pci ehci_hcd lpc_ich snd_timer pps_core mfd_core 
thinkpad_acpi nvram snd soundcore wmi evdev binfmt_misc loop vhost_net tun 
kvm_intel kvm nfsd exportfs auth_rpcgss nfs_acl lockd sunrpc dm_mod pcmcia 
sr_mod cdrom sdhci_pci yenta_socket sdhci mmc_core uhci_hcd usbcore usb_common 
video backlight autofs4
Pid: 50, comm: kworker/u:3 Not tainted 3.9.0-rc1-00114-gd356175 #144
Call Trace:
  [<ffffffff81040440>] warn_slowpath_common+0x70/0xa0
  [<ffffffff810404bc>] warn_slowpath_fmt+0x4c/0x50
  [<ffffffff8133922b>] check_unmap+0xfb/0x9a0
  [<ffffffff81339b2f>] debug_dma_unmap_page+0x5f/0x70
  [<ffffffffa05a3108>] il3945_hw_txq_free_tfd+0xc8/0x1f0 [iwl3945]
  [<ffffffffa04b02a6>] il_tx_queue_unmap+0x46/0x60 [iwlegacy]
  [<ffffffffa04b435d>] il_tx_queue_free+0x3d/0x130 [iwlegacy]
  [<ffffffffa05a366d>] il3945_hw_txq_ctx_free+0x3d/0x80 [iwl3945]
  [<ffffffffa059e6b8>] __il3945_down+0x308/0x330 [iwl3945]
  [<ffffffffa059e708>] il3945_down+0x28/0x60 [iwl3945]
  [<ffffffffa059eb09>] il3945_bg_restart+0x99/0xb0 [iwl3945]
  [<ffffffff81064486>] process_one_work+0x1f6/0x690
  [<ffffffff81064424>] ? process_one_work+0x194/0x690
  [<ffffffff81064c95>] worker_thread+0x115/0x3d0
  [<ffffffff81064b80>] ? rescuer_thread+0x260/0x260
  [<ffffffff8106e8ce>] kthread+0xde/0xf0
  [<ffffffff8106e7f0>] ? insert_kthread_work+0x70/0x70
  [<ffffffff8157eedc>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106e7f0>] ? insert_kthread_work+0x70/0x70
---[ end trace af4ae3f2874322ec ]---
Mapped at:
  [<ffffffff813385b1>] debug_dma_map_page+0x91/0x140
  [<ffffffffa059fde4>] il3945_mac_tx+0x404/0xa50 [iwl3945]
  [<ffffffffa0528e81>] __ieee80211_tx+0x121/0x3e0 [mac80211]
  [<ffffffffa052b458>] ieee80211_tx+0xd8/0x100 [mac80211]
  [<ffffffffa052b81b>] ieee80211_xmit+0x8b/0xb0 [mac80211]
ieee80211 phy0: Hardware restart was requested
Ebtables v2.0 registered


Meanwhile  Network manager is getting confused

  iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
  iwl3945 0000:03:00.0: Loaded firmware version: 15.32.2.9
  iwl3945 0000:03:00.0: Start IWL Error Log Dump:
  iwl3945 0000:03:00.0: Status: 0x000202E4, count: 1
  iwl3945 0000:03:00.0: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
  iwl3945 0000:03:00.0: SYSASSERT     (0x5) 0000201255 0x008B6 0x00274 0x00320 
0x04CA6 116

  iwl3945 0000:03:00.0: Error Reply type 0x00000005 cmd C_TX (0x1C) seq 0x0000 
ser 0x00740000
  iwl3945 0000:03:00.0: Error: Response NULL in 'C_ADD_STA'
  iwl3945 0000:03:00.0: Adding station ff:ff:ff:ff:ff:ff failed.
  iwl3945 0000:03:00.0: Error setting Tx power (-5).
  iwl3945 0000:03:00.0: Can't stop Rx DMA.
  ieee80211 phy0: Hardware restart was requested


And driver is effectively unusable - since it's just restarting....

Also 'state' of iwl3945 in  3.8 is quite 'far' from stable as well.
quite often I can see, that I'm disconnected from AP, and while
network manager shows other 'visible' AP available for connection,
my home AP is not listed anymore - and to see it again I'd to switch
wifi support on/off - just after this I'd reattach to my home AP - so quite 
annoying - and major reason to stay with 3.7 kernel for stable wifi.

Zdenek

