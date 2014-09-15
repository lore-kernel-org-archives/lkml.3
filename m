Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaIOK0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:26:23 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:34419 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaIOK0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:26:21 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "jolsa@kernel.org" <jolsa@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dev@codyps.com" <dev@codyps.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "acme@redhat.com" <acme@redhat.com>, "bp@suse.de" <bp@suse.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH] perf tools: fix type mismatch - long vs __statfs_word
Thread-Topic: [PATCH] perf tools: fix type mismatch - long vs __statfs_word
Thread-Index: AQHPtxiSMpVplk2F5E6FGwMCG/ETGJwCDysA
Date: Mon, 15 Sep 2014 10:26:01 +0000
Message-ID: <1410776760.5875.5.camel@abrodkin-8560l.internal.synopsys.com>
References: <1407949429-25421-1-git-send-email-abrodkin@synopsys.com>
	 <C2D7FE5348E1B147BCA15975FBA230753C5D0B10@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230753C5D0B10@IN01WEMBXA.internal.synopsys.com>
Reply-To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.121.8.123]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D298604507A11B4194A1609B723025C8@internal.synopsys.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8FAQTF6014065

Hi Arnaldo, Jiri,

> On Wednesday 13 August 2014 10:34 PM, Alexey Brodkin wrote:
> > From "include/uapi/asm-generic/statfs.h" it is seen that "statfs.f_type" is of
> > type "__statfs_word" which in its turn is "__u32" (unsigned int) for 32-bit
> > systems.
> >
> > So in case of compilation with "-Werror" following breakage happens:
> > --->---
> > fs.c: In function â€˜fs__valid_mountâ€™:
> > fs.c:76:24: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
> >   else if (st_fs.f_type != magic)
> >                         ^
> > cc1: all warnings being treated as errors
> > --->---
> >
> > Note that now when fs.c is in "lib/api/fs" and in "tools/lib/api/Makefile"
> > CFLAGS has hard-coded "-Werror" this is inevitable even if one builds "perf"
> > with "WERROR=0".
> >

I'm wondering if there's a chance to get this patch accepted because for
now perf building from 3.15 kernels onward is broken.

Regards,
Alexey
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
