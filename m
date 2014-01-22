Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaAVQdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 11:33:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaAVQc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 11:32:58 -0500
Date: Wed, 22 Jan 2014 11:32:44 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, tangchen@cn.fujitsu.com
Subject: hang on early boot, numa init code stack overflow?
Message-ID: <20140122163244.GA24936@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	tangchen@cn.fujitsu.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing a hang during boot on my test box running the current tree,
It doesn't always happen, perhaps one in five boots.
I managed to get a partial trace after booting with earlyprintk=vga

dump_stack
panic
? numa_clear_kernel_node_hotplug
__stack_chk_fail
numa_clear_kernel_node_hotplug
? memblock_search_pfn_nid
? __early_pfn_to_nid
numa_init
x86_numa_init
initmem_init
setup_arch
start_kernel

Looks like something overflowed the stack.
This is just a quad-core i5, nothing fancy numa-wise.

This code was added in a0acda917284183f9b71e2d08b0aa0aea722b321

	Dave

