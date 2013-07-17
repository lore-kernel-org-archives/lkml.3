Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3GQQcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:32:21 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:40204 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab3GQQcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:32:19 -0400
Date: Wed, 17 Jul 2013 18:32:15 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Subject: commit f8f559422b (KVM: MMU: fast invalidate all mmio sptes) causes
 hang
Message-ID: <20130717163215.GA359@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit:
 commit f8f559422b6c6a05469dfde614b67789b6142cb5
 Author: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
 Date:   Fri Jun 7 16:51:26 2013 +0800

    KVM: MMU: fast invalidate all mmio sptes

causes my kvm qemu qcow2 images to hang when they switch from the boot
console to the desktop. For example:
 qemu-system-x86_64 -enable-kvm -net nic,vlan=0,model=virtio -net user -drive file=ubuntu,if=virtio,cache=unsafe -smp 2 -m 1024
boots normally at first, but then hangs as soon as Xorg gets started.`

Perf top shows:
 20.99%  [kernel]                                  [k] svm_vcpu_run
 17.24%  [kernel]                                  [k] handle_mmio_page_fault_common
 15.61%  [kernel]                                  [k] kvm_arch_vcpu_ioctl_run
 12.49%  [kernel]                                  [k] fast_page_fault.part.78

I'm running:
QEMU emulator version 1.4.2 
on an AMD PhenomII X4 CPU.

-- 
Markus
