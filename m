Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbaGIXdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:33:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:58752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbaGIXdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:33:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,634,1400050800"; 
   d="scan'208";a="570853299"
From: "Luck, Tony" <tony.luck@intel.com>
To: Havard Skinnemoen <hskinnemoen@google.com>,
        Andi Kleen <andi@firstfloor.org>
CC: Borislav Petkov <bp@alien8.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Subject: RE: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP
 and CMCI reports.
Thread-Topic: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP
 and CMCI reports.
Thread-Index: AQHPm7VRKQRI444FeUKUaXDupa/8IJuYveoA//+l3oA=
Date: Wed, 9 Jul 2014 23:32:53 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F328578D2@ORSMSX114.amr.corp.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-5-git-send-email-hskinnemoen@google.com>
	<87a98inucv.fsf@tassilo.jf.intel.com>
 <CAFQmdRZejRwbk90kZoN777EO+a5VN8+AaXcjeqLzSBT6U2QfRw@mail.gmail.com>
In-Reply-To: <CAFQmdRZejRwbk90kZoN777EO+a5VN8+AaXcjeqLzSBT6U2QfRw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s69NXPG4003655

> I don't think we got the description right here. I think the real
> issue here was machine check polls happening on multiple CPUs with
> shared banks, all reporting the same MCEs. This is very reproducible
> when booting with mce=no_cmci, since all CPUs will handle all banks,
> and there's AFAICT no good way to identify shared banks without
> enabling CMCI.

Ok - then update the description to enumerate the problem cases.
Probably:

*) mce=no_cmci
*) Intel cpus with MCG_CAP.MCG_CMCI_P=0
*) AMD cpus (they don't do CMCI at all, do they??)

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
