Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3KYKMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:12:53 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44172 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753134Ab3KYKMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:12:48 -0500
Date: Mon, 25 Nov 2013 07:11:48 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Hans Zhang <zhanghonghui@innofidei.com>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        zhouguangming@innofidei.com
Subject: Re: [PATCH] Make the mtdblock read/write skip the bad nand sector
Message-ID: <20131125101147.GA2408@localhost>
References: <1385024065-29965-1-git-send-email-zhanghonghui@innofidei.com>
 <CACQ1gAiLesYEWmHkivAF=t8ekCFM=yDDyzkJTtduavNjp1g6wA@mail.gmail.com>
 <528EB1E3.7030101@innofidei.com>
 <20131122015237.GB3509@localhost>
 <528EBD0B.5010006@innofidei.com>
 <20131122114509.GB2414@localhost>
 <5292A7E7.5060003@innofidei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5292A7E7.5060003@innofidei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 09:29:11AM +0800, Hans Zhang wrote:
> On 2013/11/22 19:45, Ezequiel Garcia wrote:
> >> Thanks for your reply.
> >> This is for my embed system upgrade, I reserved one nand partition for filesystem
> >> environment which will load to DDR while uboot booting.
> >> This filesystem.uboot file should be able to read both by uboot and kernel, and
> >> maybe written by uboot and kernel. There will be no filesystems upon the nand in
> >> case the loader may not support some filesystem types while uboot booting.
> >>
> >> Seems that the trimmed environment of OS has get rid of the mtd-tools, So the dd
> >> command was the most convenience tools to use by hand.
> >>
> > I still don't understand why are you using mtdblock. Why can't you write
> > through the char device?
> 
> Well, yes, write through the char device would be a solution.

But, *why* are you writing through mtdblock instead?

> I think that maybe it's an optional approach through mtdblock in case we do not have
> the mtd-tools in our environments, we do provider a simpler way to write the NAND
> through mtdblock.
> 

Uh? simpler? Writing through mtdchat is as simple as it gets:

  $ cat some_file.img > /dev/mtd0

Sorry, but I'm still confused at what are you trying to accomplish.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
