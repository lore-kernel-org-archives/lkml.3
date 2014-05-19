Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaESDok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 23:44:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48144 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752271AbaESDoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 23:44:37 -0400
Date: Mon, 19 May 2014 00:43:55 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: "Gupta, Pekon" <pekon@ti.com>, David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] mtd: Add sysfs attr to expose ECC stats
Message-ID: <20140519034355.GB1062@arch.cereza>
References: <1395403064-28113-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1395403064-28113-2-git-send-email-ezequiel.garcia@free-electrons.com>
 <20980858CB6D3A4BAE95CA194937D5E73EAB91D7@DBDE04.ent.ti.com>
 <20140401111359.GA3324@arch.cereza>
 <20980858CB6D3A4BAE95CA194937D5E73EAC31AE@DBDE04.ent.ti.com>
 <20140513005053.GZ28907@ld-irv-0074>
 <20140513022614.GA1447@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140513022614.GA1447@arch.cereza>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 May 11:26 PM, Ezequiel Garcia wrote:
> On 12 May 05:50 PM, Brian Norris wrote:
> > > There are some guidelines about attributes in 'Documentation/filesystems/sysfs.txt'
> > > Though it's acceptable to put array of values of the "same type" in single sysfs file,
> > > But I'm still not confident on having all members of 'struct ecc_stats' being
> > > represented by single sysfs file
> > [...]
> > 
> > I agree, it looks like the sysfs policy would recommend against putting
> > distinct properties in the same file.
> > 
[..]
> > So I personally might lean toward "one file per attribute" here.
> > 

Brian,

Having agreed on doing one file per attribute, I'm now not sure how to
name them. Maybe you can give me a hand?

Let me add some context: these are the per-MTD partition fields of the
mtd_ecc_stats struct, although two of them aren't related to ECC, but to
the bad blocks management. This is the struct:

struct mtd_ecc_stats {
        __u32 corrected;
        __u32 failed;
        __u32 badblocks;
        __u32 bbtblocks;
};

How about the following?

* corrected_bits
* uncorrectable_errors
* badblocks
* bbtblocks
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
