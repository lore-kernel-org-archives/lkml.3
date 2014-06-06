Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaFFVHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:07:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:5047 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaFFVHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:07:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,991,1392192000"; 
   d="scan'208";a="543802355"
Message-ID: <53922D7F.8090601@linux.intel.com>
Date: Fri, 06 Jun 2014 14:07:11 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, gorcunov@openvz.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, luto@amacapital.net,
        mingo@kernel.org, sasha.levin@oracle.com, stefani@seibold.net,
        tglx@linutronix.de, xemul@parallels.com, kbuild@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [GIT PULL] x86/vdso changes for v3.16
References: <201406042235.s54MZgwP020553@terminus.zytor.com> <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>
In-Reply-To: <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 02:00 PM, Andrew Morton wrote:
> On Wed, 4 Jun 2014 15:35:42 -0700 "H. Peter Anvin" <hpa@linux.intel.com> wrote:
> 
>> Vdso cleanups and improvements largely from Andy Lutomirski.
> 
> arch/x86/vdso/vdso2c.h: In function 'go64':
> arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le64toh'
> arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le32toh'
> arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le16toh'
> arch/x86/vdso/vdso2c.h:119: warning: implicit declaration of function 'htole16'
> 
> My Fedora Core 6 (lol gotcha) test box doesn't have these.
> 
> http://www.unix.com/man-page/linux/3/le64toh/ has some details.  I
> don't appear to have letoh64 and friends either.  
> 

OK... so now we have a tools baseline problem.  It isn't that we
couldn't open-code these functions, but of course we'd also like to not
*have* to do so... but also we don't want to have the kernel build rely
on autoconf ;)

So we have a few options, here:

1. We could use the unaligned macros defined in
   tools/include/tools/*_byteshift.h.

2. Open-code it.

3. Define a baseline which includes these kinds of functions.

I guess I would be leaning toward #1, but would also wonder if that also
means we should add -I$(srctree)/tools/include to the global settings
... we are *already* adding it to HOSTCFLAGS_sortextable.o.

Thoughs?

	-hpa

