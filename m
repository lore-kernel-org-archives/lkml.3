Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220Ab3BMR0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:26:53 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:55191
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759726Ab3BMR0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:26:50 -0500
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT003.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: PS3(zz98dI936eI1432Ic74nzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Thread-Topic: [PATCH] x86: Lock down MSR writing in secure boot
Thread-Index: AQHOBjA7mQsIMlqU/k+EElzc7Yz1iZhwVXgAgAAAbACAAAawAIAACLcAgAABPICAAAKrAIAAAdKAgAAHwICAABjCAIAAChOAgAAFkwCAACBDAIAAAhCAgABYQICAAC3GgIAAX64AgAVYBQCAAFFaAIAACSmAgAAEVgCAAAGkAIAAAlCAgACyhQCAAAGlgA==
Date: Wed, 13 Feb 2013 17:26:39 +0000
Message-ID: <1360776399.18083.39.camel@x230.lan>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	     <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
	     <1360355671.18083.18.camel@x230.lan>
	     <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
	     <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>
	     <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>
	     <1360373383.18083.23.camel@x230.lan>
	     <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>
	     <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>
	    <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>
	   <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan>
	  <511B33BC.9080307@zytor.com> <1360737709.18083.36.camel@x230.lan>
	 <511BCB6E.8080102@zytor.com>
In-Reply-To: <511BCB6E.8080102@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <218534E4FFAC3A4E931CB5AB88AF53CA@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1DHQpCe031631

On Wed, 2013-02-13 at 09:20 -0800, H. Peter Anvin wrote:

> Problem:
> 
> Someone adds SYS_CAP_RAWIO to some places it definitely does not
> belong.
> 
> Solution:
> 
> Break all the *appropriate* (as defined)uses of SYS_CAP_RAWIO?

Problem:

CAP_SYS_RAWIO has been used in a bunch of arguably inappropriate places.
Removing CAP_SYS_RAWIO from the set of possible capabilities on a system
will prevent userspace from doing things that userspace should be
permitted to do. Removing CAP_SYS_RAWIO from the places that it
currently exists will allow userspace to do too much. Replacing
CAP_SYS_RAWIO with CAP_SYS_ADMIN will prevent userspace from doing
things that it can currently do.

Solution:

Admit that CAP_SYS_RAWIO is fucked up beyond rescue. Add a new
capability with well-defined semantics.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
