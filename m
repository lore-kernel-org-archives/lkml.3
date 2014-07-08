Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaGHAIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:08:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:33741 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbaGHAIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:08:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,622,1400050800"; 
   d="scan'208";a="539972530"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>
Subject: RE: [PATCH v2 5/7] ACPI/SFI: Fix wrong <acpi/acpi.h> inclusion in
 SFI/ACPI wrapper - table definitions.
Thread-Topic: [PATCH v2 5/7] ACPI/SFI: Fix wrong <acpi/acpi.h> inclusion in
 SFI/ACPI wrapper - table definitions.
Thread-Index: AQHPmin0ffTTa5XEmEi9KFQI3W5oJJuVTE8g
Date: Tue, 8 Jul 2014 00:08:05 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880263346A@SHSMSX101.ccr.corp.intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
 <cover.1404706298.git.lv.zheng@intel.com>
 <aebcb30aa6db54f92fcdf55f94462da15121886d.1404706299.git.lv.zheng@intel.com>
 <6888009.veyX2bKRlF@vostro.rjw.lan>
In-Reply-To: <6888009.veyX2bKRlF@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6808HJp009788

Hi,

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Tuesday, July 08, 2014 5:25 AM
> 
> On Monday, July 07, 2014 12:17:28 PM Lv Zheng wrote:
> > This patch removes <acpi/acpi.h> inclusions from <linux/sfi_acpi.h> as
> > <linux/acpi.h> has already included it for CONFIG_ACPI=n builds.
> 
> So are patches [1-4/5] only needed to fix this particular issue?

To fix this issue, we only need patch 1-5.
After applying these patches, all ACPICA structures are visible to the entire linux kernel.

Thanks and best regards
-Lv

> 
> > Cc: Len Brown <lenb@kernel.org>
> > Cc: sfi-devel@simplefirmware.org
> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > ---
> >  include/linux/sfi_acpi.h |    3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
> > index 4723bbf..a6e555c 100644
> > --- a/include/linux/sfi_acpi.h
> > +++ b/include/linux/sfi_acpi.h
> > @@ -63,8 +63,6 @@
> >  #include <linux/sfi.h>
> >
> >  #ifdef CONFIG_SFI
> > -#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
> > -
> >  extern int sfi_acpi_table_parse(char *signature, char *oem_id,
> >  				char *oem_table_id,
> >  				int (*handler)(struct acpi_table_header *));
> > @@ -78,7 +76,6 @@ static inline int __init acpi_sfi_table_parse(char *signature,
> >  	return sfi_acpi_table_parse(signature, NULL, NULL, handler);
> >  }
> >  #else /* !CONFIG_SFI */
> > -
> >  static inline int sfi_acpi_table_parse(char *signature, char *oem_id,
> >  				char *oem_table_id,
> >  				int (*handler)(struct acpi_table_header *))
> >
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
