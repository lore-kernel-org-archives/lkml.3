Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3BNCrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 21:47:11 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59098 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712Ab3BNCrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 21:47:08 -0500
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT004.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Casey Schaufler <casey@schaufler-ca.com>, Borislav Petkov <bp@alien8.de>,
        Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Thread-Topic: [PATCH] x86: Lock down MSR writing in secure boot
Thread-Index: AQHOBjA7mQsIMlqU/k+EElzc7Yz1iZhwVXgAgAAAbACAAAawAIAACLcAgAABPICAAAKrAIAAAdKAgAAHwICAABjCAIAAChOAgAAFkwCAACBDAIAAAhCAgABYQICAAC3GgIAAX64AgAVYBQCAAFFaAIAACSmAgAAEVgCAAAGkAIAAAlCAgACyhQCAAAGlgIAABt2AgABM/ICAAAjdAIAAGGYAgAAFWoCAAAV5AIAAATmAgAAbZQA=
Date: Thu, 14 Feb 2013 02:46:58 +0000
Message-ID: <1360810018.18083.47.camel@x230.lan>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	       <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
	       <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>
	       <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>
	       <1360373383.18083.23.camel@x230.lan>
	       <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>
	       <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>
	      <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>
	     <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan>
	    <511B33BC.9080307@zytor.com> <1360737709.18083.36.camel@x230.lan>
	   <511BCB6E.8080102@zytor.com> <1360776399.18083.39.camel@x230.lan>
	  <511BD291.1040003@schaufler-ca.com> <511C1325.5060601@zytor.com>
	  <511C1A94.8020804@schaufler-ca.com> <511C2F0C.3060803@zytor.com >
	  <511C3389.5090604@schaufler-ca.com> <1360803872.18083.46.camel@x230.lan>
	 <511C3927.90603@zytor.com>
In-Reply-To: <511C3927.90603@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FBCAA12208A514D9020B70E8C285B81@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1E2lISN002163

On Wed, 2013-02-13 at 17:08 -0800, H. Peter Anvin wrote:

> Well, for at least things with device nodes (/dev/mem, /dev/msr and so
> on) it should be possible, no?  ioperm() and iopl() are another matter.

Sure, if we can guarantee that a signed userspace loads a signed SELinux
policy before any unsigned code runs. But, realistically, that's not
going to be possible.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
