Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaEMBGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 21:06:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:15232 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaEMBGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 21:06:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1039,1389772800"; 
   d="scan'208";a="537978130"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "RobertBMoore@compuserve.com" <RobertBMoore@compuserve.com>,
        "Thomas Renninger (trenn@suse.de)" <trenn@suse.de>,
        Oswald Buddenhagen <ossi@kde.org>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ACPICA: Revert "ACPICA: Add option to favor 32-bit FADT
 addresses."
Thread-Topic: [PATCH] ACPICA: Revert "ACPICA: Add option to favor 32-bit
 FADT addresses."
Thread-Index: AQHPbXRxwkRy6JhDskiQoqlTZHFjU5s8H5gggACCWGCAAHw3AIAAj3sA
Date: Tue, 13 May 2014 01:05:59 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880255B8DD@SHSMSX101.ccr.corp.intel.com>
References: <38907770.bupFXhytsS@vostro.rjw.lan>
 <1AE640813FDE7649BE1B193DEA596E880255B3F0@SHSMSX101.ccr.corp.intel.com>
 <1AE640813FDE7649BE1B193DEA596E880255B72C@SHSMSX101.ccr.corp.intel.com>
 <2640573.uiu9DRCeSI@vostro.rjw.lan>
In-Reply-To: <2640573.uiu9DRCeSI@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4D16H7i023428

Hi,

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Tuesday, May 13, 2014 8:09 AM
> 
> On Monday, May 12, 2014 08:51:36 AM Zheng, Lv wrote:
> > Hi, Rafael
> >
> > I checked the bug.
> >
> > The dmesg of the kernel without the bisected commit:
> > [    0.000000] ACPI BIOS Warning (bug): Incorrect checksum in table [XSDT] - 0xA0, should be 0xC9 (20140214/tbprint-218)
> > [    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20140214/tbfadt-395)
> > [    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT - 0xCF661F40/0x00000000CF667E40, using 32
> (20140214/tbfadt-522)
> >
> > The dmesg of the kernel with the bisected commit:
> > [    0.000000] ACPI BIOS Warning (bug): Incorrect checksum in table [XSDT] - 0xA0, should be 0xC9 (20131218/tbprint-214)
> > [    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT: 0xCF661F40/0x00000000CF667E40, using 64-bit
> address (20131218/tbfadt-271)
> >
> > This is the purpose of the bisected commit.
> > According to the link below:
> > http://bugs.acpica.org/show_bug.cgi?id=885
> > And Windows documentation:
> > http://download.microsoft.com/download/5/b/9/5b97017b-e28a-4bae-ba48-174cf47d23cd/CPA002_WH06.ppt
> > We believe 64-bit addresses should be used by default so that new features can be enabled according to the public knowledge of
> Windows Vista+ behavior.
> > For old Windows, it's hard for us to guess, we should wait for the reports and add quirks for them.
> >
> > Thus this commit is not wrong, it shouldn't be reverted.
> 
> It is wrong, because it breaks a system that worked without it.
> 
> It's *that* simple.

For this commit, we knew there would be systems broken.
And was prepared to add quirks for them.
The quirks are not there just because we rely on end users to report.

> 
> And either you have a fix for that (which is not a quirk, because there may be
> more machines like that), or we have to revert it.
> 
> > Though this platform is newer than vista, we still should offer a quirk mechanism
> > for it as a quick fix:
> 
> We didn't need a quirk for it before, though.

But according to BZ885, we need more quirks for other machines before.
For example, ThinkPad 40e and ThinkPad 51e reported in the BZ885.

> 
> So really, I'm reverting it.

OK.
I'll first try to figure out the cause of the issue that is happening to Intel DP45SG.
And then try this approach again in a smarter way that is more tolerant torward the possible regressions.

Thanks and best regards
-Lv

> 
> Thanks!
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
