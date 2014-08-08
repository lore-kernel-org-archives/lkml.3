Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbaHHMnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:43:10 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:20894 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbaHHMnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:43:05 -0400
X-IronPort-AV: E=Sophos;i="5.01,825,1400025600"; 
   d="scan'208";a="160657787"
Message-ID: <53E4C5D5.2090103@citrix.com>
Date: Fri, 8 Aug 2014 13:43:01 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Kees Cook <keescook@chromium.org>, David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] Xen PV domain regression with KASLR enabled (kernel
 3.16)
References: <53E4B281.5050302@canonical.com>
In-Reply-To: <53E4B281.5050302@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/14 12:20, Stefan Bader wrote:
> Unfortunately I have not yet figured out why this happens, but can confirm by
> compiling with or without CONFIG_RANDOMIZE_BASE being set that without KASLR all
> is ok, but with it enabled there are issues (actually a dom0 does not even boot
> as a follow up error).
> 
> Details can be seen in [1] but basically this is always some portion of a
> vmalloc allocation failing after hitting a freshly allocated PTE space not being
> PTE_NONE (usually from a module load triggered by systemd-udevd). In the
> non-dom0 case this repeats many times but ends in a guest that allows login. In
> the dom0 case there is a more fatal error at some point causing a crash.
> 
> I have not tried this for a normal PV guest but for dom0 it also does not help
> to add "nokaslr" to the kernel command-line.

Maybe it's overlapping with regions of the virtual address space
reserved for Xen?  What the the VA that fails?

David
