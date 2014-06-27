Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaF0LUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:20:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:54112 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbaF0LUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:20:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,560,1400050800"; 
   d="scan'208";a="450711519"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Greg KH <greg@kroah.com>, dann frazier <dann.frazier@canonical.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Peng Tao <bergwolf@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: Re: [PATCH] staging/lustre: disable virtual block device for 64K
 pages
Thread-Topic: [PATCH] staging/lustre: disable virtual block device for 64K
 pages
Thread-Index: AQHPjIKJKbyy+hxxPkuFf74N5IPJWpuE6zoA
Date: Fri, 27 Jun 2014 11:20:06 +0000
Message-ID: <CFD2ABC9.ADA2F%andreas.dilger@intel.com>
References: <20140619183321.GA23200@fluid.dannf>
 <20140619191051.GA26573@kroah.com> <4592947.kMtdJTsB2U@wuerfel>
In-Reply-To: <4592947.kMtdJTsB2U@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.128.239]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <237E3D2B61C7E24BA07B20FE6A10FC16@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch looks mostly OK, though I see there is also a
CONFIG_PPC_256K_PAGES
define that should probably be handled.

Cheers, Andreas

On 2014/06/20, 6:23 AM, "Arnd Bergmann" <arnd@arndb.de> wrote:

>The lustre virtual block device cannot handle 64K pages and fails at
>compile
>time. To avoid running into this error, let's disable the Kconfig option
>for this driver in cases it doesn't support.
>
>Reported-by: Dann Frazier <dann.frazier@canonical.com>
>Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
>---
>On Thursday 19 June 2014 12:10:51 Greg KH wrote:
>> On Thu, Jun 19, 2014 at 12:33:21PM -0600, dann frazier wrote:
>> > drivers/staging/lustre/lustre/llite/lloop.c:523:18: error: previously
>>used here
>> >   CLASSERT(PAGE_CACHE_SIZE < (1 << (sizeof(unsigned short) * 8)));
>> >                   ^
>> 
>> Looks like lustre can't handle 64K page sizes, so it refuses to build :(
>> 
>> I sugest turning this code off, you really don't want to be running it
>> anyway...
>
>something like this?
>
>diff --git a/drivers/staging/lustre/lustre/Kconfig
>b/drivers/staging/lustre/lustre/Kconfig
>index 209e4c7..4f65ba1 100644
>--- a/drivers/staging/lustre/lustre/Kconfig
>+++ b/drivers/staging/lustre/lustre/Kconfig
>@@ -57,4 +57,5 @@ config LUSTRE_TRANSLATE_ERRNOS
> config LUSTRE_LLITE_LLOOP
> 	tristate "Lustre virtual block device"
> 	depends on LUSTRE_FS && BLOCK
>+	depends on !PPC_64K_PAGES && !ARM64_64K_PAGES
> 	default m
>
>


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


