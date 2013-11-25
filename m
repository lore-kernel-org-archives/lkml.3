Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3KYMaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:30:05 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44932 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751128Ab3KYMaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:30:03 -0500
Date: Mon, 25 Nov 2013 09:30:13 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Hans Zhang <zhanghonghui@innofidei.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        zhouguangming@innofidei.com
Subject: Re: [PATCH] Make the mtdblock read/write skip the bad nand sector
Message-ID: <20131125123012.GE2408@localhost>
References: <528EB1E3.7030101@innofidei.com>
 <20131122015237.GB3509@localhost>
 <528EBD0B.5010006@innofidei.com>
 <20131122114509.GB2414@localhost>
 <5292A7E7.5060003@innofidei.com>
 <20131125101147.GA2408@localhost>
 <CACQ1gAi26WeiopptcZmBp6h0a5TacLo5mvVCOm6-H_1HtnwvXg@mail.gmail.com>
 <529334D9.2030204@innofidei.com>
 <20131125115238.GC2408@localhost>
 <1385381770.24518.18.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385381770.24518.18.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Mon, Nov 25, 2013 at 12:16:10PM +0000, David Woodhouse wrote:
> On Mon, 2013-11-25 at 08:52 -0300, Ezequiel Garcia wrote:
> > 
> > Your understanding is correct: NAND *must* be erased explictly in
> > userspace
> > before writing. However, keep in mind the following additional
> > constraints:
> > 
> > * Writing should be always performed using 'nandwrite',
> >   not tools such as 'cat' or 'dd'.
> > 
> > * An mtdblock shouldn't be used to access directly the NAND from
> >   userspace. AFAICS, the primarily usage of mtdblock is to be able to
> >   mount JFFS2.
> 
> No. You don't need mtdblock to mount JFFS2 at all.
> 
> The mtdblock driver was used in the *very* early days of the MTD system,
> on NOR flash with a "traditional" file system. Either in read-only mode
> for something like cramfs, or in a very unsafe writeable mode. We
> actually put ext2 on it for the Compaq iPaq for a while, before we had
> JFFS.
> 
> It was used as a shortcut for mounting JFFS2, and still is by a lot of
> people, but it's certainly not necessary. You can turn off CONFIG_BLOCK
> entirely and still use JFFS2.
> 
> You should consider mtdblock to be the most basic, primitive, "flash
> translation layer" that can possibly exist. And thus, should basically
> never use it. I certainly don't approve of trying to extend it.
> 

Thanks a lot for the insight. After reading this, I'm wondering what's
preventing us from killing MTD block support altogether. Artem, already
suggested it a while back...
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
