Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3KAC6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 22:58:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:38589 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab3KAC6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 22:58:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="383116154"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: RE: [PATCH 0/4] ACPICA: Stable material of ACPI executer fixes for
 linux-3.8.
Thread-Topic: [PATCH 0/4] ACPICA: Stable material of ACPI executer fixes for
 linux-3.8.
Thread-Index: AQHO1dXjUZkF5USl+0y2+Rv7udewtZoOKeaAgAAIPACAAAO7gIABXvmg
Date: Fri, 1 Nov 2013 02:58:16 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880247A0C8@SHSMSX101.ccr.corp.intel.com>
References: <cover.1383181113.git.lv.zheng@intel.com>
 <2226874.g7cLvQ5SiE@vostro.rjw.lan> <20131031120850.GA17048@kroah.com>
 <18963273.JtsE7nd0JW@vostro.rjw.lan>
In-Reply-To: <18963273.JtsE7nd0JW@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rA12wlHw030283

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Thursday, October 31, 2013 8:22 PM
> 
> On Thursday, October 31, 2013 05:08:50 AM Greg Kroah-Hartman wrote:
> > On Thu, Oct 31, 2013 at 12:39:21PM +0100, Rafael J. Wysocki wrote:
> > > On Thursday, October 31, 2013 09:07:40 AM Lv Zheng wrote:
> > > > There are bug-fixes for AML interpreter upstreamed, fixing some serious
> > > > issues found in recent platforms.  These fixes make Linux AML interpreter
> > > > more ACPI 2.0 ASL concept compliant.  Further AML interpreter fixes should
> > > > be based on such improvements, thus they are good materials for stable.
> > > >
> > > > This patch set can be safely applied to linux-3.8:
> > > > commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200 upstream.
> > > >
> > > > The patch set has passed build/boot tests on the following machines:
> > > >   Dell Inspiron Mini 1010 (i386)
> > > >   HP Compaq 8200 Elite SFF PC (x86-64)
> > > >
> > > > Bob Moore (4):
> > > >   ACPICA: Interpreter: Fix Store() when implicit conversion is not
> > > >     possible.
> > > >   ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and
> > > >     BufferField refs.
> > > >   ACPICA: Return error if DerefOf resolves to a null package element.
> > > >   ACPICA: Fix for a Store->ArgX when ArgX contains a reference to a
> > > >     field.
> > >
> > > Hi Greg,
> > >
> > > Please take patches [1-4/4] for stable.
> >
> > "Which" stable tree?
> >
> > I don't do 3.8, it's long been end-of-life, although one company is
> > trying to keep it alive, but that's not me.
> >
> > I'm only handling 3.4, 3.10, and 3.11 stable trees right now, which
> > one(s) should these be applied to?
> 
> 3.10.x and 3.11.x then.
> 
> Lv, do the original mainline commits apply to these kernels?
> 
> Rafael

Hi, Rafael and Greg

I checked the back port dependencies since v3.8:
1. [PATCH 1] belongs to v3.9.
2. [PATCH 4] includes an empty line belonging to a coding style fix affecting this series (between [PATCH 3] and [PATCH 4]).
Thus,
1. For v3.10:
    [PATCH 1]: It's already in the repo, so please drop it.
    [PATCH 2-4]: They can be used directly as 3.10.x stable materials.
2. For v3.11:
    [PATCH 1]: It's already in the repo, so please drop it.
    [PATCH 2-3]: They can be used directly as 3.11.x stable materials.
    [PATCH 4]: The original commit from Linus' tree should be used instead.

 I checked the commit log since v3.4.
 There is no functional change done to the AML executer between v3.4 and v3.8.
 The problem is there is a coding style fix affecting this series (between v3.4 and [PATCH 1]).
 I generated the following diff block before applying [PATCH 1], and obtained a successful build/boot to a v3.4 kernel with these patches applied.
Thus,
1. For v3.4:
    [PATCH 1]: You can merge this diff block to [PATCH 1] or simply modify the [PATCH 1] by manually adding this white space.
    [PATCH 2-4]: They can be used directly as 3.4.x stable materials.

---
Index: linux-acpica/drivers/acpi/acpica/exstore.c
===================================================================
--- linux-acpica.orig/drivers/acpi/acpica/exstore.c
+++ linux-acpica/drivers/acpi/acpica/exstore.c
@@ -491,7 +491,7 @@ acpi_ex_store_object_to_node(union acpi_
 				  acpi_ut_get_object_type_name(source_desc),
 				  source_desc, node));
 
-		/* No conversions for all other types.  Just attach the source object */
+		/* No conversions for all other types. Just attach the source object */
 
 		status = acpi_ns_attach_object(node, source_desc,
 					       source_desc->common.type);
---

Thanks and best regards
-Lv
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
