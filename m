Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab3AJXMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:12:37 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47585 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab3AJXMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:12:36 -0500
Message-ID: <50EF4AD1.4060807@linux.vnet.ibm.com>
Date: Thu, 10 Jan 2013 15:12:17 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: paul.szabo@sydney.edu.au
CC: linux-mm@kvack.org, 695182@bugs.debian.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reproducible OOM with partial workaround
References: <201301102158.r0ALwI4i031014@como.maths.usyd.edu.au>
In-Reply-To: <201301102158.r0ALwI4i031014@como.maths.usyd.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011023-9360-0000-0000-00000F0A043E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 01:58 PM, paul.szabo@sydney.edu.au wrote:
> I developed a workaround patch for this particular OOM demo, dropping
> filesystem caches when about to exhaust lowmem. However, subsequently
> I observed OOM when running many processes (as yet I do not have an
> easy-to-reproduce demo of this); so as I suspected, the essence of the
> problem is not with FS caches.
> 
> Could you please help in finding the cause of this OOM bug?

As was mentioned in the bug, your 32GB of physical memory only ends up
giving ~900MB of low memory to the kernel.  Of that, around 600MB is
used for "mem_map[]", leaving only about 300MB available to the kernel
for *ALL* of its allocations at runtime.

Your configuration has never worked.  This isn't a regression, it's
simply something that we know never worked in Linux and it's a very hard
problem to solve.  One Linux vendor (at least) went to a huge amount of
trouble to develop, ship, and supported a kernel that supported large
32-bit machines, but it was never merged upstream and work stopped on it
when such machines became rare beasts:

	http://lwn.net/Articles/39925/

I believe just about any Linux vendor would call your configuration
"unsupported".  Just because the kernel can boot does not mean that we
expect it to work.

It's possible that some tweaks of the vm knobs (like lowmem_reserve)
could help you here.  But, really, you don't want to run a 32-bit kernel
on such a large machine.  Very, very few folks are running 32-bit
kernels on these systems and you're likely to keep running in to bugs
because this is such a rare configuration.

We've been very careful to ensure that 64-bit kernels shoul basically be
drop-in replacements for 32-bit ones.  You can keep userspace 100%
32-bit, and just have a 64-bit kernel.

If you're really set on staying 32-bit, I might have a NUMA-Q I can give
you. ;)

