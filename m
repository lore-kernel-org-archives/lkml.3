Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaCYWBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:01:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49595 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751378AbaCYWBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:01:08 -0400
Date: Tue, 25 Mar 2014 19:00:45 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        angus.clark@st.com, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        pekon@ti.com, computersforpeace@gmail.com, dwmw2@infradead.org
Subject: Re: [RFC 00/47] mtd: nand: Add new driver supporting ST's BCH h/w
Message-ID: <20140325220045.GA12185@arch.cereza>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <20140325125050.GB665@arch.cereza>
 <20140325131139.GB24823@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140325131139.GB24823@lee--X1>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 25, Lee Jones wrote:
> On Tue, 25 Mar 2014, Ezequiel Garcia wrote:
> 
> > Hi Lee,
> > 
> > On Mar 25, Lee Jones wrote:
> > > 
> > > This patch-set was written against kernel version v3.4, but applies
> > > cleanly to v3.13-rc7 which it is currently based. I understand that
> > > the core has changed significantly since and that some of the
> > > infrastructure this driver provides is now available either through
> > > the framework or similar means. I'm looking for someone with inside
> > > knowledge to draw attention to those areas so we can align with the
> > > most recent API.
> > > 
> > 
> > Please push a git branch. It will be nice to have a way of seeing the 'big
> > picture' without applying the 47 patches.
[..]
> 
>   git://git.linaro.org/people/lee.jones/linux-3.0-ux500.git tb-st-mtd-nand-bch
> 

Lee,

After taking a quick glance at the whole driver I noticed you have something
strange going on. AFAIK, the typical NAND driver probe() should be one of
these two:

* Call nand_scan() which calls nand_scan_ident() + nand_scan_tail().

* Call nand_scan_ident() to identify the NAND device geometry, do some
  driver specific initialization, fill some hooks, and finally call
  nand_scan_tail() to complete the initialization.

You driver call nand_scan_ident() and then does some bad block scan, and
fills some callbacks on its own, but never calls nand_scan_tail().

The call to nand_scan_tail() would remove the need to export those NAND
core functions, and remove the need to scan and print the bad blocks.
I don't know if you have a real reason for not doing it this way, or
maybe it's the way this driver was originally written.

Care to review this and re-spin the driver? You'll have a more nicer
driver, and more framework-compliant.

Also, if you plan to target v3.16 on this, I'd suggest that you pick
some pack of features and submit those first, reducing the amount of code
to be reviewed. For instance, you may choose to leave some of the ECC bits
aside for now.

It's just a suggestion to get at least some of the code merged quicker,
don't take me too seriously on this.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
