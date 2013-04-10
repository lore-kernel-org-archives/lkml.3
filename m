Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936385Ab3DJWXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:23:37 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33766 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759724Ab3DJWXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:23:35 -0400
X-Sasl-enc: skLdXyCTzvXyi3UV9FfmK/xJUyUkmsDpGaOwMFbeEs1+ 1365632614
Date: Wed, 10 Apr 2013 15:23:33 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@vger.kernel.org>, hpa@linux.intel.com,
        Mel Gorman <mgorman@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [stable 3.0 revert request] x86-32, mm: Remove reference to
 resume_map_numa_kva()
Message-ID: <20130410222333.GA2139@kroah.com>
References: <515EB8B6.3070900@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515EB8B6.3070900@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 01:42:46PM +0200, Jiri Slaby wrote:
> Hi,
> 
> in 3.0.67 there is this commit:
> commit dbb694e810c87e7e1760527a783437f26ac5a547
> Author: H. Peter Anvin <hpa@linux.intel.com>
> Date:   Thu Jan 31 13:53:10 2013 -0800
> 
>     x86-32, mm: Remove reference to resume_map_numa_kva()
> 
>     commit bb112aec5ee41427e9b9726e3d57b896709598ed upstream.
> 
>     Remove reference to removed function resume_map_numa_kva().
> 
> 
> 
> But it depends on f03574f2 (which was applied to 3.2, 3.4, 3.7 and 3.8
> stable trees, but not to 3.0). Now, when f03574f2 is not there, resume
> from suspend dies terrible death on 32-bit:
> Enabling non-boot CPUs ...
> ------------[ cut here ]------------
> kernel BUG at mm/slab.c:532!
> invalid opcode: 0000 [#1] SMP
> 
> 
> In 3.0, we need either f03574f2:
> commit f03574f2d5b2d6229dcdf2d322848065f72953c7
> Author: Dave Hansen <dave@linux.vnet.ibm.com>
> Date:   Wed Jan 30 16:56:16 2013 -0800
> 
>     x86-32, mm: Rip out x86_32 NUMA remapping code
> 
> or revert the commit above...

I've applied f03574f2 to the 3.0-stable tree, thanks for letting me
know.

greg k-h
