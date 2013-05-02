Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839Ab3EBOJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:09:34 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61387 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866Ab3EBOJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:09:33 -0400
Date: Thu, 2 May 2013 07:08:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: [stable 3.0] s390 build breakage [was: Linux 3.0.75]
Message-ID: <20130502140855.GA24348@kroah.com>
References: <20130426043017.GA22553@kroah.com>
 <51826176.2070104@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51826176.2070104@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 02:52:06PM +0200, Jiri Slaby wrote:
> On 04/26/2013 06:30 AM, Greg KH wrote:
> > Linus Torvalds (5): vm: add vm_iomap_memory() helper function
> 
> Hi, this one breaks s390 on 3.0:
> mm/memory.c: In function 'vm_iomap_memory':
> mm/memory.c:2363: error: implicit declaration of function
> 'io_remap_pfn_range'
> 
> It looks like 4f2e29031e6c67802e7370292dd050fd62f337ee is needed:
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Apr 17 08:46:19 2013 -0700
> 
>     s390: move dummy io_remap_pfn_range() to asm/pgtable.h
> 
> 
> But it depends on the s390 PCI support...
> 
> Whatever, it should be OK to take only the second hunk from that
> patch, it seems.

Ah, sorry about that, for some reason I didn't think this patch was
needed on s390.  I'll queue this up for the next stable release.

thanks,

greg k-h
