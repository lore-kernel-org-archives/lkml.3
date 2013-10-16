Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934378Ab3JPND1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:03:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:6444 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934104Ab3JPND0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:03:26 -0400
Date: Wed, 16 Oct 2013 09:03:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] x86: Remove WARN_ON(in_nmi()) from vmalloc_fault
Message-ID: <20131016090325.11daee3a@gandalf.local.home>
In-Reply-To: <20131016125111.GB2611@gmail.com>
References: <20131015163906.342d8ffa@gandalf.local.home>
	<20131016061118.GA21109@gmail.com>
	<20131016084219.53deac7a@gandalf.local.home>
	<20131016125111.GB2611@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013 14:51:11 +0200
Ingo Molnar <mingo@kernel.org> wrote:


> So kallsyms_lookup() faulted, while the NMI watchdog triggered a 
> show_regs()? How is that possible?

It was a vmalloc fault. Do modules keep their symbol tables in a
vmalloced area? If so, I think the get_ksymbol() can fault when
searching for a module address.

-- Steve
