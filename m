Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaA3XF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 18:05:27 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40447 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbaA3XFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 18:05:25 -0500
Date: Thu, 30 Jan 2014 15:05:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@intel.com>, Tony Luck <tony.luck@intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Gong Chen <gong.chen@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>, yinghai@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com
Subject: Re: [PATCH] x86, cpu hotplug, Fix stack frame warning in
 check_irq_vectors_for_cpu_disable()
In-Reply-To: <1390915331-27375-1-git-send-email-prarit@redhat.com>
Message-ID: <alpine.DEB.2.02.1401301504380.12223@chino.kir.corp.google.com>
References: <1390915331-27375-1-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Prarit Bhargava wrote:

> Further discussion here: http://marc.info/?l=linux-kernel&m=139073901101034&w=2
> 
> kbuild, 0day kernel build service, outputs the warning:
> 
> arch/x86/kernel/irq.c:333:1: warning: the frame size of 2056 bytes
> is larger than 2048 bytes [-Wframe-larger-than=]
> 
> because check_irq_vectors_for_cpu_disable() allocates two cpumasks on the
> stack.   Fix this by moving the two cpumasks to a global file context.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: David Rientjes <rientjes@google.com>
