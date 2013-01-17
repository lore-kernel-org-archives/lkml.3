Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3AQRzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:55:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43217 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3AQRzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:55:48 -0500
Message-ID: <50F83AD8.8020606@canonical.com>
Date: Thu, 17 Jan 2013 12:54:32 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.7.0-rc8 - warning
References: <50BD2DB2.8040600@googlemail.com>
In-Reply-To: <50BD2DB2.8040600@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 05:54 PM, Chris Clayton wrote:
> I've built 3.7.0-rc8 and have been running it for about 40 minutes.
> I was inspecting the output from dmesg whilst trying to figure out why 
> the command "alsactl restore" is producing an error and spotted this 
> kernel warning.
>
> [  241.982633] ------------[ cut here ]------------
> [  241.982642] WARNING: at arch/x86/kernel/apic/ipi.c:109 
> default_send_IPI_mask_logical+0xa6/0xd0()
> [  241.982643] Hardware name: LIFEBOOK AH531
> [  241.982645] empty IPI mask
> [  241.982646] Modules linked in:
> [  241.982647]  iptable_filter xt_conntrack ipt_MASQUERADE iptable_nat 
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
> snd_usb_audio snd_usbmidi_lib usb_storage snd_hwdep snd_rawmidi 
> snd_seq_device coretemp snd_hda_codec_hdmi hwmon snd_hda_codec_realtek 
> fujitsu_laptop kvm_intel snd_hda_intel snd_hda_codec r8169 kvm [last 
> unloaded: microcode]
> [  241.982667] Pid: 692, comm: HTML5 Parser Not tainted 3.7.0-rc8 #77
> [  241.982668] Call Trace:
> [  241.982672]  [<c102f218>] ? warn_slowpath_common+0x78/0xb0
> [  241.982674]  [<c1021376>] ? default_send_IPI_mask_logical+0xa6/0xd0
> [  241.982676]  [<c1021376>] ? default_send_IPI_mask_logical+0xa6/0xd0
> [  241.982678]  [<c102f2e3>] ? warn_slowpath_fmt+0x33/0x40
> [  241.982680]  [<c1021376>] ? default_send_IPI_mask_logical+0xa6/0xd0
> [  241.982683]  [<c101f60f>] ? native_send_call_func_ipi+0x3f/0x60
> [  241.982688]  [<c1072be8>] ? smp_call_function_many+0x178/0x220
> [  241.982690]  [<c102bc30>] ? do_flush_tlb_all+0x60/0x60
> [  241.982692]  [<c102bcd8>] ? native_flush_tlb_others+0x28/0x30
> [  241.982694]  [<c102bfe2>] ? flush_tlb_page+0x82/0xd0
> [  241.982695]  [<c102ad41>] ? ptep_set_access_flags+0x61/0x70
> [  241.982698]  [<c10ad6ea>] ? do_wp_page+0x34a/0x7f0
> [  241.982701]  [<c10aefbd>] ? handle_pte_fault+0x49d/0x870
> [  241.982704]  [<c106fd08>] ? futex_wake+0xf8/0x120
> [  241.982706]  [<c1071397>] ? do_futex+0xf7/0x9f0
> [  241.982708]  [<c10b012a>] ? handle_mm_fault+0xda/0x140
> [  241.982711]  [<c1026fa1>] ? __do_page_fault+0x141/0x460
> [  241.982713]  [<c106653a>] ? ktime_get_ts+0x3a/0x150
> [  241.982715]  [<c107304a>] ? 
> generic_smp_call_function_interrupt+0xca/0x160
> [  241.982717]  [<c10272d0>] ? vmalloc_sync_all+0x10/0x10
> [  241.982721]  [<c13f34e6>] ? error_code+0x5a/0x60
> [  241.982723]  [<c10272d0>] ? vmalloc_sync_all+0x10/0x10
> [  241.982725] ---[ end trace a26e371ca3a2122a ]---
>
> My .config is attached.
>
> Let me know if I can provide additional diagnostics or help testing 
> any patches, but please cc me as I'm not subscribed.
>
> Chris

Hi Chris,

This has also been reported in multiple distros:

https://bugs.launchpad.net/bugs/1100202
https://bugzilla.redhat.com/show_bug.cgi?id=867174

Do you have a way to reproduce this, or does it happen at random times?

Thanks,

Joe
