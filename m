Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaFJPXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:23:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaFJPXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:23:05 -0400
Date: Tue, 10 Jun 2014 11:22:55 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: mporter@linaro.org, lee.jones@linaro.org
Subject: Re: regulator: bcm590xx: Add support for regulators on secondary I2C
 slave
Message-ID: <20140610152255.GA20737@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	mporter@linaro.org, lee.jones@linaro.org
References: <20140603192910.BB56066103D@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603192910.BB56066103D@gitolite.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 07:29:10PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=c6466950e917890be3050171f6745ccb9d91d35f
 > Commit:     c6466950e917890be3050171f6745ccb9d91d35f
 > Parent:     9e1e726311830bc5b8b568d5178f6a52c357fb6e
 > Refname:    refs/heads/next
 > Author:     Matt Porter <mporter@linaro.org>
 > AuthorDate: Wed Apr 23 19:21:32 2014 -0400
 > Committer:  Lee Jones <lee.jones@linaro.org>
 > CommitDate: Wed May 21 10:40:16 2014 +0100
 > 
 >     regulator: bcm590xx: Add support for regulators on secondary I2C slave
 >     
 >     The bcm590xx MFD driver now exposes a secondary regmap descriptor
 >     making the registers for regulators on the secondary I2C slave address
 >     available.  Add support for GPLDO1-6 and VBUS regulators found within
 >     this register range.
 
 > -#define BCM590XX_NUM_REGS	20
 > +#define BCM590XX_NUM_REGS	27

Coverity picked up that this change has introduced a out of bounds read.
The loop in bcm590xx_probe iterates from 0 to NUM_REGS,
but the bcm590xx_regs struct it iterates over using the ptr 'info' is only 26
elements.

	Dave

