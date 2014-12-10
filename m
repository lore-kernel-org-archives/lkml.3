Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbaLJJu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:50:58 -0500
Received: from ozlabs.org ([103.22.144.67]:35724 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaLJJu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:50:57 -0500
Message-ID: <1418205050.9279.5.camel@ellerman.id.au>
Subject: Re: [RFC PATCH 2/8] perf probe powerpc: Fix symbol fixup issues due
 to ELF type
From: Michael Ellerman <mpe@ellerman.id.au>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, ananth@in.ibm.com
Date: Wed, 10 Dec 2014 20:50:50 +1100
In-Reply-To: <0412a00009a22762f92c208964df6f842796464e.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
	 <0412a00009a22762f92c208964df6f842796464e.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 23:04 +0530, Naveen N. Rao wrote:
> If using the symbol table, symbol addresses are not being fixed up
> properly, resulting in probes being placed at wrong addresses:
> 
>   # perf probe do_fork
>   Added new event:
>     probe:do_fork        (on do_fork)
> 
>   You can now use it in all perf tools, such as:
> 
> 	  perf record -e probe:do_fork -aR sleep 1
> 
>   # cat /sys/kernel/debug/tracing/kprobe_events
>   p:probe/do_fork _text+635952
>   # printf "%x" 635952
>   9b430
>   # grep do_fork /boot/System.map
>   c0000000000ab430 T .do_fork

OK, but why is that happening? And why does checking for ET_DYN fix it?

> Fix by checking for ELF type ET_DYN used by ppc64 kernels.

We sometimes produce ET_DYN kernels, but only if CONFIG_RELOCATABLE=y.

cheers


