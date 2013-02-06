Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab3BFQUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:20:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63011 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab3BFQUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:20:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Wed, 6 Feb 2013 16:20:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <7613336.0C5oRATusX@wuerfel> <CACxGe6tjyx3GTgNgMRtvwhrFsTGizkeTqY_N6=2gdQjvMSD8Ug@mail.gmail.com>
In-Reply-To: <CACxGe6tjyx3GTgNgMRtvwhrFsTGizkeTqY_N6=2gdQjvMSD8Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302061620.10324.arnd@arndb.de>
X-Provags-ID: V02:K0:JayDtJ00/3TFMOrzRweSqzFAu0dV6YPxs5uy9JqR8Km
 92UxY4ZPYpIpeOLqzcTniw5HLGawab+ONRKkab9/m+kBUcWsww
 vAhe0uMtpb0awFoA9bao3jb6uvGho+qJVONgbQrX0tWS9NhHu5
 fNXSNSkr0zBrw/Eb8Ydx49W7Iq+i2HmczWKFX/NgEjID3gVEhE
 N9E3yrE5hfVrz6o4hLWvJmEOlmIA37GuWOF4A/D4PQ5MsS3rYG
 lzb9ggWWKoNLMmpsxDBivjwQ9cslRYG18XX3rvo+Sgn0k3lWZh
 21pnLQw5pIgeD1inhfo97z/k2pZzRx0aUkWJmJuGPppE1BMeMg
 T3wnza1octnYc3KmwuFY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2013, Grant Likely wrote:
> The driver already handles this. It has three sets of accessors;
> 8-bit, 16-bit LE and 16-bit BE and when doing 16-bit it figures out
> on its own which set to use at runtime. There is nothing controversial
> here. The only problem is that the driver is currently using in_/out_
> IO accessors instead of ioread/iowrite variants.

Ah right. It certainly helps to look at the source code.

	Arnd
