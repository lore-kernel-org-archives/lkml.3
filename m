Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab3CVTRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:17:34 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:3706 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754966Ab3CVTRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:17:33 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2dh2a8h668h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Yoder Stuart-B08248 <B08248@freescale.com>
To: Michael Neuling <mikey@neuling.org>,
        Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Kumar Gala <galak@kernel.crashing.org>
CC: Chen Gang <gang.chen@asianux.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "paulus@samba.org" <paulus@samba.org>,
        "matt@ozlabs.org" <matt@ozlabs.org>,
        "imunsie@au1.ibm.com" <imunsie@au1.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Suggestion] PowerPC: kernel: cross compiling issue with
 allmodconfig
Thread-Topic: [Suggestion] PowerPC: kernel: cross compiling issue with
 allmodconfig
Thread-Index: AQHOJorGAGT/OMO8gE612qsjpbbIS5iyFapA
Date: Fri, 22 Mar 2013 19:17:28 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E150358CDE5@039-SN1MPN1-002.039d.mgd.msft.net>
References: <51428C81.6000204@asianux.com>
 <25841.1363323174@ale.ozlabs.ibm.com> <5142AE27.7060003@asianux.com>
 <514AA0D9.1090509@asianux.com> <514AC418.1070806@gmail.com>
 <14121.1363908062@ale.ozlabs.ibm.com>
In-Reply-To: <14121.1363908062@ale.ozlabs.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.82.121.95]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2MJHdB9015392



> -----Original Message-----
> From: Michael Neuling [mailto:mikey@neuling.org]
> Sent: Thursday, March 21, 2013 6:21 PM
> To: Chen Gang F T; Yoder Stuart-B08248; Kumar Gala
> Cc: Chen Gang; Benjamin Herrenschmidt; sfr@canb.auug.org.au; paulus@samba.org; matt@ozlabs.org;
> imunsie@au1.ibm.com; linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: Re: [Suggestion] PowerPC: kernel: cross compiling issue with allmodconfig
> 
> Chen Gang F T <chen.gang.flying.transformer@gmail.com> wrote:
> 
> >
> >   it seems:
> >     only move slb_miss_realmode to the end, can fix this issue without negative effect.
> 
> So this works but uncovers a new bug.
> 
> Stuart: if you apply this patch allmodconfig now gets this build error
> on linux-next.
> 
> arch/powerpc/kernel/built-in.o: In function `restore_pblist_ptr':
> ftrace.c:(.toc+0xd78): undefined reference to `epapr_ev_idle_start'
> ftrace.c:(.toc+0xd88): undefined reference to `epapr_ev_idle'
> make[1]: *** [vmlinux] Error 1
> 
> Reverting your patch below fixes this:
> 
>   commit f070986a07e514e3b4fc4aef6551b8dffcb19287
>   Author: Stuart Yoder <stuart.yoder@freescale.com>
>   Date:   Fri Feb 8 13:22:56 2013 -0600
> 
>   powerpc: Add paravirt idle loop for 64-bit Book-E
> 
>   Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
>   Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> 
> Should we revert your patch or can you send a fix?  This is currently
> broken in linux-next (at least next-20130321).

Sent a patch that resolves this.  Not completely happy with it
because of the added #ifdefs, but not sure how else to resolve
this.   allmodconfig is creating config combinations that don't
happen in a normal build (at least currently)-- 64-bit build
that enables EPAPR_PARAVIRT but not PPC_BOOK3E_64.

Stuart
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
