Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3KYLwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:52:41 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44698 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751913Ab3KYLwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:52:40 -0500
Date: Mon, 25 Nov 2013 08:52:39 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Hans Zhang <zhanghonghui@innofidei.com>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        zhouguangming@innofidei.com
Subject: Re: [PATCH] Make the mtdblock read/write skip the bad nand sector
Message-ID: <20131125115238.GC2408@localhost>
References: <1385024065-29965-1-git-send-email-zhanghonghui@innofidei.com>
 <CACQ1gAiLesYEWmHkivAF=t8ekCFM=yDDyzkJTtduavNjp1g6wA@mail.gmail.com>
 <528EB1E3.7030101@innofidei.com>
 <20131122015237.GB3509@localhost>
 <528EBD0B.5010006@innofidei.com>
 <20131122114509.GB2414@localhost>
 <5292A7E7.5060003@innofidei.com>
 <20131125101147.GA2408@localhost>
 <CACQ1gAi26WeiopptcZmBp6h0a5TacLo5mvVCOm6-H_1HtnwvXg@mail.gmail.com>
 <529334D9.2030204@innofidei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <529334D9.2030204@innofidei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 07:30:33PM +0800, Hans Zhang wrote:
> On 2013/11/25 18:23, Richard Genoud wrote:
> >
> > Well, yes, write through the char device would be a solution.
> >> But, *why* are you writing through mtdblock instead?
> >>
> >>> I think that maybe it's an optional approach through mtdblock in case we do not have
> >>> the mtd-tools in our environments, we do provider a simpler way to write the NAND
> >>> through mtdblock.
> >>>
> >> Uh? simpler? Writing through mtdchat is as simple as it gets:
> >>
> >>   $ cat some_file.img > /dev/mtd0
> >>
> >> Sorry, but I'm still confused at what are you trying to accomplish.
> > I think that what Hans wants to do is:
> >  $ cat some_file.img > /dev/mtd0
> > And that doesn't fail on a bad block but jumps over it.
> > ... Which is a bad idea.
> > But, likeyou, I didn't figured out why mtdblock instead of mtdchar.
> >
> >
> 
> I'm sorry it's my mistake, I thought the NAND need to be erased explicitly in userspace
> before written when through the mtdchar device. That's why I use the mtdblock instead of
> mtdchar.
> 

Your understanding is correct: NAND *must* be erased explictly in userspace
before writing. However, keep in mind the following additional constraints:

* Writing should be always performed using 'nandwrite',
  not tools such as 'cat' or 'dd'.

* An mtdblock shouldn't be used to access directly the NAND from
  userspace. AFAICS, the primarily usage of mtdblock is to be able to
  mount JFFS2.

Out of curiosity, what's your NAND layout? What FS are you using?
Unless you have some special requirement, you should be using UBI to
access the device (and not MTD).

Just a suggestion...
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
