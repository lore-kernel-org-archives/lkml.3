Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbaIRCz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:55:58 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61993 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbaIRCz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:55:57 -0400
Message-ID: <541A49B9.2070009@gmail.com>
Date: Thu, 18 Sep 2014 04:55:53 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: Re: debug_dma_assert_idle - ohci - cpu touching an active dma mapped
 cacheline
References: <534F01D1.9000206@gmail.com> <534F858B.4060208@ladisch.de> <53500CDB.8050802@gmail.com> <53570F1F.1000709@gmail.com> <53575099.1030501@gmail.com> <5361D69E.1060802@gmail.com> <53684172.6090402@gmail.com> <536A0777.1050407@gmail.com> <536F4ACA.3040300@gmail.com> <54011F5D.5040809@gmail.com>
In-Reply-To: <54011F5D.5040809@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------[ cut here ]------------
WARNING: CPU: 2 PID: 1065 at lib/dma-debug.c:593 debug_dma_assert_idle+0x159/0x1d0()
ohci-pci 0000:00:04.0: DMA-API: cpu touching an active dma mapped cacheline [cln=0x03004180]
CPU: 2 PID: 1065 Comm: tumblerd Not tainted 3.17.0-0.rc5.git1.1.fc22.i686 #1
Call Trace:
 [<c0b1bdb6>] dump_stack+0x48/0x60
 [<c04591e2>] warn_slowpath_common+0x82/0xa0
 [<c076dad9>] ? debug_dma_assert_idle+0x159/0x1d0
 [<c076dad9>] ? debug_dma_assert_idle+0x159/0x1d0
 [<c045923e>] warn_slowpath_fmt+0x3e/0x60
 [<c076dad9>] debug_dma_assert_idle+0x159/0x1d0
 [<c059a909>] ? anon_vma_prepare+0x29/0x140
 [<c058f594>] do_wp_page+0xe4/0x8c0
 [<c0591792>] handle_mm_fault+0x662/0xba0
 [<c0447398>] __do_page_fault+0x208/0x5d0
 [<c058053b>] ? vm_mmap_pgoff+0x9b/0xc0
 [<c0595178>] ? SyS_mmap_pgoff+0xe8/0x220
 [<c04a8e1c>] ? trace_hardirqs_on_caller+0x13c/0x1e0
 [<c0447760>] ? __do_page_fault+0x5d0/0x5d0
 [<c044777a>] do_page_fault+0x1a/0x20
 [<c0b258b4>] error_code+0x6c/0x74
---[ end trace ce8b30fb8a3415c9 ]---
Mapped at:
 [<c076bb82>] debug_dma_alloc_coherent+0x22/0x70
 [<c09050dc>] ohci_init+0x22c/0x450
 [<c0905359>] ohci_setup+0x59/0x60
 [<c09064cf>] ohci_pci_reset+0x4f/0x60
 [<c08dd8aa>] usb_add_hcd+0x29a/0x8c0

$ lsusb -s 004:
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub


poma


