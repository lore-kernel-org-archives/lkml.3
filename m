Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab3BKPoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:44:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255Ab3BKPoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:44:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Mon, 11 Feb 2013 15:43:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <201302111526.37892.arnd@arndb.de> <CAHTX3dJxevq3v-o1E6SEM-hFQ4aYi-hkgefX5+-hOmtqy6JgWg@mail.gmail.com>
In-Reply-To: <CAHTX3dJxevq3v-o1E6SEM-hFQ4aYi-hkgefX5+-hOmtqy6JgWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302111543.46196.arnd@arndb.de>
X-Provags-ID: V02:K0:8R1lm+JtLWTwwdhLSWEMweTm4NJk0sxJjmTX5t5+w/K
 82auOJIB2ogWyQGOlV8nYVIaRoIS4bhDz8AZQmvZud0ARW5O7n
 CBIpzQrYs3OKCTm87cfGcbDsyc23IBGhynBJMneObdeNHRr/yE
 lG9gR6ZwL1zIMXXvLOSqmKY6vzxdaZX/O+ENvWLFCgb1G1eHii
 Uv806mTHCp+S0Wu1Z9ufkARGAA0dBUCOhLpebQP6qmlxt0x7xX
 6jxpt24Yg91+8PwliwDj8uJM6T9h0aXjN4JoYizInG7TUYkz3f
 QHppx/HmrVnNg1aKpG/suTUBxji3QYznmPnEwUo22oJvnRFlBW
 J16BGHUFO+wMgZFhtIiI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2013, Michal Simek wrote:
> I have just found that it won't be so easy as I thought because I have found
> that microblaze wrong implementation was done because of others device drivers.
> It means that I have to fix all device drivers to support big and
> little endian accessors
> first before I can switch microblaze to asm-generic/io.h. :-(
> 
> BTW: If you want to take this patch though your tree then ok, or it
> can go through my
> microblaze tree. Both ways should just work.

Please use your tree then. I don't have any asm-generic patches
lined up for 3.9 myself, so we can save me and Linus a little work
with a trivial pull request that way.
 
> I will send the patch for uarlite when I finish my testing on
> microblaze, ppc and arm.

Ok. Is that the only one that you found to require the "wrong-endian" mode
in microblaze.

	Arnd
