Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbaD1ENF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 00:13:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:34877 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbaD1ENB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 00:13:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,941,1389772800"; 
   d="scan'208";a="522160882"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH v2 1/5] ACPICA: OSL: Add direct inclusion of extra
 header.
Thread-Topic: [PATCH v2 1/5] ACPICA: OSL: Add direct inclusion of extra
 header.
Thread-Index: AQHPYl4Q+2XQuDtKtEK4uCbw6q01MpsmV8eg
Date: Mon, 28 Apr 2014 04:12:44 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88025586C7@SHSMSX101.ccr.corp.intel.com>
References: <cover.1396930406.git.lv.zheng@intel.com>
 <cover.1398232408.git.lv.zheng@intel.com>
 <43884d194fd55ca9124078d3374ec4cf4a8026ef.1398232408.git.lv.zheng@intel.com>
 <3997362.yjEHqV8nv6@vostro.rjw.lan>
In-Reply-To: <3997362.yjEHqV8nv6@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3S4DEBo020304

Hi, Rafael

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Monday, April 28, 2014 5:34 AM
> 
> On Wednesday, April 23, 2014 02:53:52 PM Lv Zheng wrote:
> > This is a linuxized result of an ACPICA commit to upgrade the extra
> > header mechanism.
> >
> > This patch enhances the extra header solution to allow Linux to use
> > ACPI_USE_NATIVE_INTERFACE_HEADER and the file name can be automatically
> > replaced during ACPICA release process. Using this way, the rest of the
> > ACPICA users needn't know the name of the extra header file. Lv Zheng.
> >
> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > ---
> >  include/acpi/acpi.h |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/acpi/acpi.h b/include/acpi/acpi.h
> > index ca0cb60..682398b 100644
> > --- a/include/acpi/acpi.h
> > +++ b/include/acpi/acpi.h
> > @@ -62,8 +62,8 @@
> >  #include <acpi/acrestyp.h>		/* Resource Descriptor structs */
> >  #include <acpi/acpiosxf.h>		/* OSL interfaces (ACPICA-to-OS) */
> >  #include <acpi/acpixf.h>		/* ACPI core subsystem external interfaces */
> > -#ifdef ACPI_NATIVE_INTERFACE_HEADER
> > -#include ACPI_NATIVE_INTERFACE_HEADER
> > +#ifdef ACPI_USE_NATIVE_INTERFACE_HEADER
> > +#include <acpi/acpi_opt.h>
> >  #endif
> >
> >  #endif				/* __ACPI_H__ */
> 
> Well, I still think there's a better way.
> 
> Introduce <acpi/platform/acenvex.h> into ACPICA and put this into it:
> 
> #if defined(_LINUX) || defined(__linux__)
> #include <acpi/platform/aclinuxex.h>
> 
> #endif
> 
> and then move stuff you want in acpi/acpi_opt.h into acpi/platform/aclinuxex.h.
> 
> Then, you'll have in acpi.h:
> 
> #include <acpi/acrestyp.h>		/* Resource Descriptor structs */
> #include <acpi/acpiosxf.h>		/* OSL interfaces (ACPICA-to-OS) */
> #include <acpi/acpixf.h>		/* ACPI core subsystem external interfaces */
> #include <acpi/platform/acenvex.h>	/* Extra environment-specific items */
> 
> 
> That should work I suppose, shouldn't it?

I think this should work.
I'll modify this patch according the above suggestion.

Thanks and best regards
-Lv

> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
