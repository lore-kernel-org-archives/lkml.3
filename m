Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbaF3NNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:13:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54204 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbaF3NNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:13:14 -0400
Date: Mon, 30 Jun 2014 15:13:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: /proc/cpuinfo confusion with AMD processors
Message-ID: <20140630131309.GA5199@pd.tnic>
References: <53B15D27.9010306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53B15D27.9010306@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 08:50:47AM -0400, Prarit Bhargava wrote:
> AMD defines a "Package" as the hardware processor itself.  Each Package contains
> multiple Nodes, and each Node has multiple Compute Units.  Each Compute Unit can
> have up to 2 cores that [with the 62xx and 63xx] do not have multiple Threads.
> 
> That is, to determine the number of CPUs that Linux sees, multiply
> 
>      Package * Nodes * Compute Units * Cores
> 
> Note that Nodes and Compute Units are not indicated in /proc/cpuinfo directly
> (although it could be argued that they should be).
> 
> The output of /proc/cpuinfo is confusing at this point as ...
> 
> 
> processor       : 31
> vendor_id       : AuthenticAMD
> cpu family      : 21
> model           : 2
> model name      : AMD Opteron(tm) Processor 6386 SE
> stepping        : 0
> microcode       : 0x6000822
> cpu MHz         : 2800.000
> cache size      : 2048 KB
> physical id     : 1
> siblings        : 16  <<< this is number of threads per package
> core id         : 7   <<< this is the core id of this thread relative to node
> cpu cores       : 8   <<< this is the number of cores per node

siblings / cpu cores = threads per compute unit.

> which makes deciphering the system topology quite difficult as values are
> relative to both nodes and the entire package.  It is not possible using this
> information to uniquely identify a processor.

To do what with that information? What is the task you're trying to
accomplish?

> Thoughts/concerns?

BIOS does all kinds of hacks and renumbering to accomodate the
brainf*cked design of other OSes so this info you're trying to put in
cpuinfo might turn to be completely misleading utterly useless in some
cases.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
