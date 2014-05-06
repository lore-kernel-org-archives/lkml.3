Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693AbaEFBjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:39:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:2870 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933469AbaEFBjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:39:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,993,1389772800"; 
   d="scan'208";a="535190347"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Josh Boyer <jwboyer@fedoraproject.org>
CC: Lv Zheng <zetalog@gmail.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: RE: [PATCH 20/27] ACPICA: Tables: Fix invalid pointer accesses in
 acpi_tb_parse_root_table().
Thread-Topic: [PATCH 20/27] ACPICA: Tables: Fix invalid pointer accesses in
 acpi_tb_parse_root_table().
Thread-Index: AQHPZ/iuve4rvQgJnEi8eqtq/mEgq5sxYmJQgAAGmACAAMlvAIAAinjA
Date: Tue, 6 May 2014 01:39:04 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802559DCE@SHSMSX101.ccr.corp.intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
 <1AE640813FDE7649BE1B193DEA596E8802559B1C@SHSMSX101.ccr.corp.intel.com>
 <CA+5PVA58527N76yJ8yNZPAbOz6YepR3RHXtjaV6t0i1nCYwcXg@mail.gmail.com>
 <6913597.VSrPZ98ePF@vostro.rjw.lan>
In-Reply-To: <6913597.VSrPZ98ePF@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s461dWfk007259

Hi,

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Tuesday, May 06, 2014 8:44 AM
> 
> On Monday, May 05, 2014 08:42:46 AM Josh Boyer wrote:
> > On Mon, May 5, 2014 at 12:23 AM, Zheng, Lv <lv.zheng@intel.com> wrote:
> > > Hi, Rafael
> > >
> > >> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> > >> Sent: Monday, May 05, 2014 8:43 AM
> > >>
> > >> On Saturday, May 03, 2014 08:59:14 AM Josh Boyer wrote:
> > >> > On Tue, Apr 29, 2014 at 10:05 PM, Lv Zheng <lv.zheng@intel.com> wrote:
> > >> > > The commit of back porting Linux XSDT validation mechanism has introduced
> > >> > > a regreession:
> > >> > >   Commit: 671cc68dc61f029d44b43a681356078e02d8dab8
> > >> > >   Subject: ACPICA: Back port and refine validation of the XSDT root table.
> > >> > > There is a pointer still accessed after unmapping.
> > >> > >
> > >> > > This patch fixes this issue.  Lv Zheng.
> > >> > >
> > >> > > Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=73911
> > >> > > Buglink: https://bugs.archlinux.org/task/39811
> > >> > > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > >> > > Reported-and-tested-by: Bruce Chiarelli <mano155@gmail.com>
> > >> > > Reported-and-tested-by: Spyros Stathopoulos <spystath@gmail.com>
> > >> > > Signed-off-by: Bob Moore <robert.moore@intel.com>
> > >> > > Cc: <stable@vger.kernel.org> # 3.14.x: 671cc68: ACPICA: Back port and refine validation of the XSDT root table.
> > >> >
> > >> > This patch should get into 3.15-rcX soon.  It fixes a known regression
> > >> > that prevents booting on machines with AMI firmware, and that is
> > >> > present in 3.14 so we need it for stable as well.  Rafael?
> > >>
> > >> Lv, is it safe to take this patch alone into 3.15-rc?
> > >
> > > Yes, it's safe to only take this patch to be a regression fix.
> >
> > FWIW, Fedora is carrying this on top of 3.14.2 already, and people
> > with the impacted machines say it's working for them.  So I agree it
> > should be safe.
> >
> > Thanks to the both of you.
> 
> OK, queued up for 3.15, thanks!

Actually there are 2 fixes in the same patch set for this issue:
One is a regression fix for commit 671cc68 - let me call it "Solution 1 - ill formed XSDT skipping".
 https://patchwork.kernel.org/patch/4090591/
The other is a different approach to solve the old issue that is fixed by solution 1 - let me call it "Solution 2 - R/XSDT NULL entry skipping".
 https://patchwork.kernel.org/patch/4090511/
 https://patchwork.kernel.org/patch/4090501/

And if you want to know the whole story before making further decisions.

The commit 671cc68 is introduced to reduce the ACPICA divergences.
Lacking in platforms having such ill formed XSDT shipped, I only unit tested the commit in ACPICA development environment where AcpiOsUnmapMemory() is a no-op.
Thus the buggy commit is leaked to the Linux kernel during the ACPICA release cycle.

When fixing the regression here: https://bugzilla.kernel.org/show_bug.cgi?id=73911
At first, the root cause is not addressed due to the same test incapability, thus it comes the solution 2 to solve the old issue in a different way.
As the solution 1 prevents higher versioned tables to be used while solution 2 enables higher versioned tables,
I believe solution 2 is more correct than the old approach.
The solution 2 is based on ACPICA 201403 release, for kernel v3.14, a completely different stable material is generated.

In the meanwhile, the regression is root caused.
Though the regression fix may not be useful if the solution 2 is proven to be more correct,
ACPICA also merged this regression fix in order to generate a stable material for Linux.

I'm not sure if patches for solution 2 also need to be merged using the short-cut path.
Possibly not as the solution 2 changed old behavior of Linux, so they are not urgent stable materials.

Thanks and best regards
-Lv

> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
