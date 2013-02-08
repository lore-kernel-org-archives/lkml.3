Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947100Ab3BHUwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:52:51 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:23076
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946936Ab3BHUwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:52:50 -0500
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dIc89bh936eIzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Kees Cook <keescook@chromium.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Thread-Topic: [PATCH] x86: Lock down MSR writing in secure boot
Thread-Index: AQHOBjA7mQsIMlqU/k+EElzc7Yz1iZhwVXgAgAAAbACAAAawAIAACLcAgAABPICAAAKrAIAAAdKA
Date: Fri, 8 Feb 2013 20:34:31 +0000
Message-ID: <1360355671.18083.18.camel@x230.lan>
References: <20130208191213.GA25081@www.outflux.net>
	 <00780235-deac-4f80-b936-867834e05661@email.android.com>
	 <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
	 <5115553A.5000708@zytor.com>
	 <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>
	 <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	 <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
In-Reply-To: <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA29DA631E563D46A770BFA754550B0D@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r18Kqosv005978

On Fri, 2013-02-08 at 12:28 -0800, Kees Cook wrote:

> Maybe a capability isn't the right way to go, I'm not sure. I'll leave
> that to Matthew. Whatever the flag, it should be an immutable state of
> the boot. Though, it probably makes sense as a cap just so that
> non-secure-boot systems can still remove it from containers, etc.

There was interest in ensuring that this wasn't something special-cased
to UEFI Secure Boot, so using a capability seemed like the most
straightforward way - it's fundamentally a restriction on what an
otherwise privileged user is able to do, so it seemed like it fit the
model. But I'm not wed to it in the slightest, and in fact it causes
problems for some userspace (anything that drops all capabilities
suddenly finds itself unable to do something that it expects to be able
to do), so if anyone has any suggestions for a better approachâ€¦
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
