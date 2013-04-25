Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab3DYWXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:23:40 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:54875
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933200Ab3DYWXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:23:39 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT001.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zz98dI9371I936eI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bh8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Josh Boyer <jwboyer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Paul Bolle <pebolle@tiscali.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 fixes for 3.9
Thread-Topic: [GIT PULL] x86 fixes for 3.9
Thread-Index: AQHOQf43GXGT08TKE06E/vWIpcYzjJjngiKAgAAA4QA=
Date: Thu, 25 Apr 2013 22:23:24 +0000
Message-ID: <1366928604.9976.3.camel@x230>
References: <201304252144.r3PLihDe025383@terminus.zytor.com>
	 <CA+55aFxxWXrQU4oZUbHOBBkvtF=pSxMvyF6sYU9xpSDarWV-=Q@mail.gmail.com>
In-Reply-To: <CA+55aFxxWXrQU4oZUbHOBBkvtF=pSxMvyF6sYU9xpSDarWV-=Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9497FCBA12BB424B8F682958DA3D578B@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3PMNkIQ031859

On Thu, 2013-04-25 at 15:20 -0700, Linus Torvalds wrote:
> On Thu, Apr 25, 2013 at 2:44 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> >
> > -       if (!sys_table->runtime->query_variable_info)
> > +       if (sys_table->runtime->hdr.revision < EFI_2_00_SYSTEM_TABLE_REVISION)
> >                 return EFI_UNSUPPORTED;
> 
> Is a EFI 2.00 system table *guaranteed* to have that
> "query_variable_info" function? The above adds the version check, but
> removes the check for a NULL pointer.

As far as the spec's concerned, yes. As far as reality's concerned - if
anything doesn't provide it, we're already crashing when
efi_virt_query_variable_info() gets called. Nobody's complained so far.

> And why the hell don't we have a real structure that has been filled
> out properly, and instead apparently just do this "point to random
> memory that doesn't necessarily have the full structure?

This is early boot code, we're not in the kernel proper yet. All we have
is the structure that's handed to us by the firmware, and the size of
that structure varies depending on its version.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
