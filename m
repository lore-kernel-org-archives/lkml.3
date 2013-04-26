Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3DZPkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:40:05 -0400
Received: from mx0.aculab.com ([213.249.233.131]:40454 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753884Ab3DZPkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:40:03 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [RFC PATCH net-next 2/6] x86: bpf_jit_comp: support BPF_S_ANC_SECCOMP_LD_W instruction
Date: Fri, 26 Apr 2013 16:38:09 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7209@saturn3.aculab.com>
In-Reply-To: <1366990066.8964.216.camel@edumazet-glaptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH net-next 2/6] x86: bpf_jit_comp: support BPF_S_ANC_SECCOMP_LD_W instruction
Thread-Index: Ac5CkoFFkLsaa4ipTmyGhl2v7JZRogAAL8XQ
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com> <1366962706-24204-3-git-send-email-xi.wang@gmail.com> <1366985926.8964.190.camel@edumazet-glaptop> <CAKU6vyZfYR-2408G0_Fkp-PS5x5rMH+s4_OOWqqi7Nt+UfiUPg@mail.gmail.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7208@saturn3.aculab.com> <1366990066.8964.216.camel@edumazet-glaptop>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: "Xi Wang" <xi.wang@gmail.com>, "Daniel Borkmann" <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>,
        "Eric Dumazet" <edumazet@google.com>, "Will Drewry" <wad@chromium.org>,
        "Andrew Morton" <akpm@linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3QFeBwK004465

> > > >> +                             func = (u8 *)seccomp_bpf_load;
> > > >> +                             t_offset = func - (image + addrs[i]);
> > > >> +                             EMIT1_off32(0xbf, K); /* mov imm32,%edi */
> > > >> +                             EMIT1_off32(0xe8, t_offset); /* call seccomp_bpf_load */
> > > >> +                             break;
> > > >> +#endif
> > > >
> > > > This seems seriously wrong to me.
> > >
> > > Can you elaborate?
> >
> > The 'call seccomp_bpf_load' needs a pc-relative offset,
> > I assume that is what EMIT1_off32() generates.
> >
> > The other two instructions want an absolute 32 bit value...
> 
> Hmm, this part is fine, we perform the relative adjustments in
> t_offset = func - (image + addrs[i]);

The call needs the displacement from the address of
the instruction following the call.
I can't imagine any way in which above can allow for the 5 byte
'mov imm32,%edi' instruction.

I'd have thought there would be an EMIT1_imm32().
(I've written a lot of x86 asm in my days!)

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
