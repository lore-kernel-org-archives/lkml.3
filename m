Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3COKPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:15:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54300 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3COKPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:15:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] isdn: hisax: netjet requires VIRT_TO_BUS
Date: Fri, 15 Mar 2013 10:15:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        David Howells <dhowells@redhat.com>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de> <1363298204-8014-4-git-send-email-arnd@arndb.de> <CAMuHMdVhjnX_hag5Y5VvDWVcjPK8tMM-qx-TQ2x=M88yTZQwYg@mail.gmail.com>
In-Reply-To: <CAMuHMdVhjnX_hag5Y5VvDWVcjPK8tMM-qx-TQ2x=M88yTZQwYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303151015.00746.arnd@arndb.de>
X-Provags-ID: V02:K0:KYrjk10tcGityumB7JplWJAAngfc5qa+f7QCwkhf7oe
 jqbNlxzi25BpwNPg5WvCEcIBBaWvygj+YtEVAYpXJHq0i5MV5i
 bEkPdR5RSJI3zK/PAjT8hj3KUxlCn8TVKNct05ccp+BHI4FQm9
 N1kvhKaGInaqQxnnBtPsFzKxpE1wZ5Y7jM4vBGGTuEPhQZXtwx
 8y3gj98FLCtzVY5+xTOliGNO1L6evF+d3W6EcSrFTsiAqUNfAg
 rB6WK/DUPiqyBKChtNg/t4EIGUMd550Fp8Sn7mI3IpxehBWNgB
 gIofII6aLn59lLpgdZdgu7QHI5hzQREyrS+NPyQxMnxsvq851P
 +hbq0N5k80aBoIRTwjuA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013, Geert Uytterhoeven wrote:
> On Thu, Mar 14, 2013 at 10:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > Disabling CONFIG_VIRT_TO_BUS on ARM showed that the hisax netjet
> > driver depends on this deprecated functionality but is not
> > marked so in Kconfig.
> >
> > Rather than adding ARM to the already long list of architectures
> > that this driver is broken on, this patch adds 'depends on
> > VIRT_TO_BUS' and removes the dependency on !SPARC, which is
> > also implied by that.
> 
> IIRC, the real "arch" dependency for this driver is !BIG_ENDIAN, but
> unfortunately
> we don't have a generic Kconfig symbol for that.
> Perhaps we may want to introduce that?
> Of course we prefer to make drivers work on all endianness instead...

CONFIG_VIRT_TO_BUS is certainly also a dependency, since it fails
to build without that. I think we can address the two problems separately.

David Howells brought up the topic of endian checks recently, noting
that the way we define __BIG_ENDIAN and __LITTLE_ENDIAN in the kernel
is incompatible to how do it in user space, and not much better either.

A few architectures that are bi-endian (arc, arm, c6x, mips, sh) already
have CONFIG_CPU_IS_LITTLE_ENDIAN and CONFIG_CPU_IS_BIG_ENDIAN. I guess
it would be a good idea to provide these on all architectures.

	Arnd
