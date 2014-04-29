Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbaD2HvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:51:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:13492 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbaD2HvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:51:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,949,1389772800"; 
   d="scan'208";a="425254313"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH v2 5/5] ACPICA: Remove deprecated _LINUX definitions for
 ACPICA.
Thread-Topic: [PATCH v2 5/5] ACPICA: Remove deprecated _LINUX definitions
 for ACPICA.
Thread-Index: AQHPYl7HvEJpVi0nxUqUK5Xuhp0dyJsmaDvAgACNRACAAUTOcA==
Date: Tue, 29 Apr 2014 07:50:37 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802558BBD@SHSMSX101.ccr.corp.intel.com>
References: <cover.1396930406.git.lv.zheng@intel.com>
 <cover.1398232408.git.lv.zheng@intel.com>
 <8e6c90efc629b463709aef5da4957e916fdc0437.1398232409.git.lv.zheng@intel.com>
 <2215223.yYQsuKoaSF@vostro.rjw.lan>
 <1AE640813FDE7649BE1B193DEA596E88025586A7@SHSMSX101.ccr.corp.intel.com>
 <535EB986.9060802@intel.com>
In-Reply-To: <535EB986.9060802@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3T7pOhx030560

Hi,

> From: Wysocki, Rafael J
> Sent: Tuesday, April 29, 2014 4:27 AM
> 
> On 4/28/2014 6:10 AM, Zheng, Lv wrote:
> > Hi, Rafael
> >
> >> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> >> Sent: Monday, April 28, 2014 5:39 AM
> >>
> >> On Wednesday, April 23, 2014 02:54:22 PM Lv Zheng wrote:
> >>> There are _LINUX defined so that when Linux kernel is compiled using broken
> >>> compilers that having not __linux__ defined can still include
> >>> <acpi/platform/aclinux.h> from <acpi/platform/acenv.h>.
> >>>
> >>> This behavior is deprecated as all drivers/acpi/acpica files are compiled
> >>> without including <linux/acpi.h>, thus without _LINUX defined.  As there is
> >>> no issues encountered when we compile ACPICA code without _LINUX defined,
> >>> it is OK to remove _LINUX from <linux/acpi.h> now.
> >>>
> >>> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> >>> ---
> >>>   include/linux/acpi.h |    4 ----
> >>>   1 file changed, 4 deletions(-)
> >>>
> >>> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> >>> index 7a8f2cd..9c559f7 100644
> >>> --- a/include/linux/acpi.h
> >>> +++ b/include/linux/acpi.h
> >>> @@ -31,10 +31,6 @@
> >>>
> >>>   #ifdef	CONFIG_ACPI
> >>>
> >>> -#ifndef _LINUX
> >>> -#define _LINUX
> >>> -#endif
> >>> -
> >>>   #include <linux/list.h>
> >>>   #include <linux/mod_devicetable.h>
> >> What about <acpi/platform/acenv.h>?  Should it still check if _LINUX is defined
> >> after this change?
> > If you mean these lines:
> >    #if defined(_LINUX) || defined(__linux__)
> >    #include <acpi/platform/aclinux.h>
> > After deleting "_LINUX" from <linux/acpi.h>, acenv.h still can include aclinux.h because of "__linux__".
> > Actually all drivers/acpi/acpica source files are compiled without including <linux/acpi.h>, so "_LINUX" defined in this file is useless to
> Linux.
> > We needn't delete "_LINUX" from acenv.h.
> >
> > "_LINUX" is only used in ACPICA makefiles, Linux never uses it:
> >    https://github.com/acpica/acpica/blob/master/generate/unix/Makefile.config
> > ACPICA can be compiled using the following make command:
> >    make HOST=_LINUX
> > I think this is the only usage of "_LINUX" for now.
> 
> Well, my point was: If we delete the definition of _LINUX, why don't we
> drop the symbol itself from everywhere along with it?
> 
> It definitely is not useful to refer to a symbol that's never defined,
> is it?

It sounds like I should clean up acenv.h first than deleting this.
OK, I'll drop this patch from this series.
I might re-do the deletion after cleaning up the acenv.h.

Thanks and best regards
-Lv

> 
> Rafael

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
