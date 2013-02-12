Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab3BLL0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 06:26:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56329 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab3BLL0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 06:26:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Tue, 12 Feb 2013 11:26:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <201302111608.29304.arnd@arndb.de> <CAHTX3dJUduUj1a5_xCfjVc0y3J4-zUKZrBpQTvSj=SVVz=gvsg@mail.gmail.com>
In-Reply-To: <CAHTX3dJUduUj1a5_xCfjVc0y3J4-zUKZrBpQTvSj=SVVz=gvsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302121126.10288.arnd@arndb.de>
X-Provags-ID: V02:K0:tW0/wgNDEOzdsuQ7m7+kDvzFMxzDOKBclEuOep3pRF2
 UNK6F0CroT67xOhE5tEv3mCnyLEdbFwOeWUPW9+AE03GMtxqs/
 +P21HBGkdHv2xyngoGDC+j//7tIdhxO2p99QmRJTjIbHFNPE88
 pr6tqsJLQxnw3vKJM5hLEksSI45TcNDHlVqMhYN/zwExm4vteT
 t7+sMRQBLlMSaNwgYAsuZmn29E5xc9FqR2SVps3OQxZGabOoWp
 +eq/Bkmvf+Dgn7JoAsy3XLrHZ5jLoKFSjfJnpO9jxuo1vJfH50
 b42vlQD0bMhEQW0egn4FQuAgbsBSYoPZn8gyB8JaihBOzORn/D
 eSuU61gPwEwLHzYIPmDQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013, Michal Simek wrote:
> > In particular, ARM can run both big- and little-endian even though
> > big-endian is rarely used, so you need to know the endianess for
> > the device you are talking to rather than assume that it knows
> > what the CPU does at the time.
> 
> For high performance IPs using accessors functions is still problematic
> because there will be performance regression it means that
> from my point of view there still should be any option to "setup"
> proper endians for the driver and it can't be setup at run-time.

I did not mean you have to use a run-time detection here, although
that is often the easiest solution. If you know the endianess of
a device for a specific architecture or platform, it is totally
fine to pick that endianess at compile-time and use e.g. the
readl_relaxed() accessors on ARM to give you the lowest access
latency.

	Arnd
