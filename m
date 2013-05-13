Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3EMWEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 18:04:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab3EMWEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 18:04:51 -0400
Date: Mon, 13 May 2013 18:04:44 -0400
From: Dave Jones <davej@redhat.com>
To: luto@amacapital.net
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: irq remapping warnings on macbook pro.
Message-ID: <20130513220444.GA22440@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, luto@amacapital.net,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy,

since commit af8d102f999a41c0189bd2cce488bac2ee88c29b, we've had
reports from users getting this backtrace..

WARNING: at drivers/iommu/intel_irq_remapping.c:658 intel_enable_irq_remapping+0x295/0x2a4()
Hardware name: MacBookPro10,1
Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.
Modules linked in:
Pid: 1, comm: swapper/0 Not tainted 3.9.1-301.fc19.x86_64 #1
Call Trace:
 [<ffffffff81d46d3b>] ? intel_enable_irq_remapping+0x295/0x2a4
 [<ffffffff8105cd86>] warn_slowpath_common+0x66/0x80
 [<ffffffff8105cdec>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffff81d46d3b>] intel_enable_irq_remapping+0x295/0x2a4
 [<ffffffff81d46e94>] irq_remapping_enable+0x1b/0x7b
 [<ffffffff81d15b6f>] enable_IR+0x59/0x60
 [<ffffffff81d15d75>] enable_IR_x2apic+0x8d/0x13f
 [<ffffffff81d17b8a>] default_setup_apic_routing+0x11/0x69
 [<ffffffff81d13a94>] native_smp_prepare_cpus+0x2c0/0x3c2
 [<ffffffff81d04f8a>] kernel_init_freeable+0xba/0x1fa
 [<ffffffff81629cb0>] ? rest_init+0x80/0x80
 [<ffffffff81629cbe>] kernel_init+0xe/0x190
 [<ffffffff8164da6c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81629cb0>] ? rest_init+0x80/0x80

examples at:

https://bugzilla.redhat.com/show_bug.cgi?id=962356
https://bugzilla.redhat.com/show_bug.cgi?id=948262
https://bugzilla.redhat.com/show_bug.cgi?id=954068

Given the unlikelyhood of Apple releasing a firmware fix to appease Linux,
can we downgrade this to just a printk ? That would at least stop
it getting picked up as a kernel bug by abrt and similar tools.

	Dave

