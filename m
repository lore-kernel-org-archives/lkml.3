Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946929Ab3BHT1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:27:24 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:42714
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946782Ab3BHT1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:27:22 -0500
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zz98dI9371I936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275ch177df4h17326ah8275bhz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Kees Cook <keescook@chromium.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Thread-Topic: [PATCH] x86: Lock down MSR writing in secure boot
Thread-Index: AQHOBjA7mQsIMlqU/k+EElzc7Yz1iZhwVXyAgAABLICAAAGKgA==
Date: Fri, 8 Feb 2013 19:27:09 +0000
Message-ID: <1360351629.18083.15.camel@x230.lan>
References: <20130208191213.GA25081@www.outflux.net>
	 <1360351047.18083.14.camel@x230.lan>
	 <CAGXu5j+aXxQb_Jyn6G+JUdjNOF2EGo9pTw8dBYuZUTb+S1vWow@mail.gmail.com>
In-Reply-To: <CAGXu5j+aXxQb_Jyn6G+JUdjNOF2EGo9pTw8dBYuZUTb+S1vWow@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D2B3823B22DE547BEB4061801F001D6@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r18JRNr3005453

On Fri, 2013-02-08 at 11:21 -0800, Kees Cook wrote:
> On Fri, Feb 8, 2013 at 11:17 AM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
> > On Fri, 2013-02-08 at 11:12 -0800, Kees Cook wrote:
> >> Writing to MSRs should not be allowed unless CAP_COMPROMISE_KERNEL is
> >> set since it could lead to execution of arbitrary code in kernel mode.
> >
> > Willing to buy this, but do you have a description of one potential
> > approach? We should probably also figure out what's writing to MSRs at
> > the moment (anything other than energy_perf_bias?) and decide what the
> > best thing to do there is.
> 
> Yes, change the SYSENTER entry point to where-ever you like. There are
> examples already written:
> http://grsecurity.net/~spender/msr32.c

Cool. Yup, this sounds like a good plan.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
