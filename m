Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3BGId3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 03:33:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55145 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab3BGIdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 03:33:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Thu, 7 Feb 2013 08:33:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: monstr@monstr.eu, Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <51135F43.4030209@monstr.eu> <CAMuHMdWWfSaO-BSMjiGpScrrtZmsAHnpSDDOMAAsFOsWEJuSow@mail.gmail.com>
In-Reply-To: <CAMuHMdWWfSaO-BSMjiGpScrrtZmsAHnpSDDOMAAsFOsWEJuSow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302070833.15443.arnd@arndb.de>
X-Provags-ID: V02:K0:6bBQsUeaUBLPOiKJwYZ01ccqdEzq7w4LMktYM5QtMlc
 I5Fcr0dsG2kanKwr28t8fT8IWF6PqmyqWtUIGa2yjMA20BkgTE
 yarWKsPyh/yBUVi6aN0M2XQXKLaWuVDKmU7sXYXSNbbuql0zrI
 /ghr6HIEWeD/DriUiHhraOnEUxc64rmbe9z0S0F0za9NgWpYgh
 5JvpgDzlOolhs51fq5gd1JUxrlZFIJpGFbOJzbM/PsdZihwg3L
 KEsl2dqx3DwSjwOWny+0LX4D6kbew9zlWqK8MqyGtXhyEETYPi
 6SXB1s2vPG36Xi7PFefXOaHfWDaILYz+LRqE2f7MGc1JEeoo6s
 8kEtAybVp2BvdbxOvAb8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Geert Uytterhoeven wrote:
> 
> On Thu, Feb 7, 2013 at 9:01 AM, Michal Simek <monstr@monstr.eu> wrote:
> > ok. Can you please confirm with me that the same problem is also for
> > iowrite32be
> > ioread16be and ioread32be?
> >
> > This description seems to me correct for BE and LE.
> > #define ioread16be(addr)       __be16_to_cpu(__raw_readw(addr))
> > #define ioread32be(addr)       __be32_to_cpu(__raw_readl(addr))
> >
> > #define iowrite16be(v, addr)   __raw_writew(__cpu_to_be16(v), addr)
> > #define iowrite32be(v, addr)   __raw_writel(__cpu_to_be32(v), addr)
> >
> > What do you think?
> 
> Looks fine to me. Arnd, Ben?

Yes, that would be better. Can you prepare a patch?

	Arnd
