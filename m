Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3DWH3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:29:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab3DWH3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:29:36 -0400
Subject: Re: memcpy_fromio in dmi_scan.c
From: Jean Delvare <jdelvare@suse.de>
To: DuanZhenzhong <zhenzhong.duan@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
In-Reply-To: <5175FF0F.9050206@oracle.com>
References: <1366636689.4503.35.camel@chaos.site>
	 <5175FF0F.9050206@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 23 Apr 2013 09:28:42 +0200
Message-ID: <1366702122.4667.11.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tuesday 23 April 2013 à 11:25 +0800, DuanZhenzhong a écrit :
> Jean Delvare wrote:
> > Hi Duan, Andrew,
> >
> > I am looking at the following commit:
> >
> > commit 9f9c9cbb60576a1518d0bf93fb8e499cffccf377
> > Author: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> > Date:   Thu Dec 20 15:05:14 2012 -0800
> >
> >     drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists
> >
> > And I am worried about calls to memcpy_fromio(), or lack thereof. Before
> > this commit, the code would take great care to always call
> > memcpy_fromio() to get data from the 0xF0000-0xFFFFF memory range (BIOS
> > data) and operate on that copy. After this commit, the code is happily
> > calling memcmp() directly on an __iomem pointer. It seems to be harmless
> > on x86, but it will break on IA64, won't it?
> >
> >   
> Hi Jean,
> What's the impact of reading bios data directly on IA64?
> Sorry I have little knowledge about IA64.

I don't have much knowledge about IA64 either. All I see is that while
x86 implements memcpy_fromio() with memcpy [1], ia64 implements it with
readb [2]. There must be a reason for that, and I can only suppose that
memcpy on __iomem pointers doesn't work on IA64. If memcpy doesn't work
then I can't see memcmp working.

[1] http://lxr.linux.no/#linux+v3.8.8/arch/x86/include/asm/io.h#L209
[2] http://lxr.linux.no/#linux+v3.8.8/arch/ia64/lib/io.c#L10

Tony, Fenghua? Did anyone test DMI support on IA64 in kernel 3.8.0+,
3.4.28+, 3.2.38+ or 3.061+?

-- 
Jean Delvare
Suse L3

