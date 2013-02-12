Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab3BLLaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 06:30:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59668 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab3BLLaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 06:30:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Tue, 12 Feb 2013 11:29:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Michal Simek <monstr@monstr.eu>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <201302111608.29304.arnd@arndb.de> <1360628974.17442.23.camel@pasglop>
In-Reply-To: <1360628974.17442.23.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302121129.54654.arnd@arndb.de>
X-Provags-ID: V02:K0:Y0wBjVfjOAwJuXfzoayE0XZNJ/AbYd3TZEi0I/pIVhf
 rd5EIYKHC/BwMcS5i8i5OC8FRoab3It4m/bqcEJq9qa3Q8ZX6g
 wNoEi/vFCbinF2K5mVetW8BtHNYf25u3Asnm0emYKrBnVpjFs8
 yHX5CI4h+N5MFOAzwIZ/A5JA3KJDR15czcvv91Gz2TalUoH+29
 /qSZA/onBNmHNY+xl4WvvAWNcHFS9qKb1iIE9ONsTikvw/dnw6
 3MVLZMlqVnH0TIwDsq4g1kXPmE5UDctwQwH6KUdElfYiaHajIm
 cVqqRnOpJnx3LIYj0QRNXOEr4k3j9oos0+YOuuYlzxgkxgNMpZ
 /uSuwu/OfX3CvDaDM3dM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013, Benjamin Herrenschmidt wrote:
> It depends how the ARM core operates vs. IO when switched between BE and
> LE, does it keep the same lines doing byte 0 or does it keep the MSB/LSB
> in the same place (and thus changes which lanes contain byte 0) ?

IIRC it changed between older and more recent ARM, at least we have
separate configuration options for "BE-8" big-endian mode on ARMv6
and above, and "BE-32" on older ones.

Currently we don't support platforms upstream that get configured
as BE-32, but the code is there and I know of people using it.

	Arnd
