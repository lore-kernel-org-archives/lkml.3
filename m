Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaDOLSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:18:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23630 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaDOLSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:18:17 -0400
Date: Tue, 15 Apr 2014 14:18:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + lib-stringc-strlcpy-might-read-too-far.patch added to -mm tree
Message-ID: <20140415111800.GW4963@mwanda>
References: <534c5757.VydWMxxcqkXGiwNa%akpm@linux-foundation.org>
 <CACVxJT-f+K_z-XxqjDVU_QK-VJPqnCEbWuMJF1fyTL0V0xiTgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVxJT-f+K_z-XxqjDVU_QK-VJPqnCEbWuMJF1fyTL0V0xiTgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 01:49:38PM +0300, Alexey Dobriyan wrote:
> Return value matters. It may not matter for kernel, because kernel is
> not heavy string user.
> But it is better to not diverge from master code:
> http://www.openbsd.org/cgi-bin/cvsweb/src/lib/libc/string/strlcpy.c?rev=1.11
> 

Oh...  Hm.  Maybe we should drop this patch then.

> Counter-rationale:
> * strlcpy() accepts strings, so if you're giving raw buffer you're
> doing it wrong.
> * last byte of last page argument is bogus because kernel copies data
> from userspace first.

The last byte of the page argument seems possible:

	foo = kmalloc();
	copy_from_user(foo, arg, sizeof(foo));
	strlcpy(dest.str, foo->bar, sizeof(dest.str));

It's a very unlikely scenario.  You have to be very unlucky to hit it at
all.

regards,
dan carpenter
