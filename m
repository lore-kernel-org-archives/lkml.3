Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207AbaJBGSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 02:18:47 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54818 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaJBGSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 02:18:45 -0400
Date: Wed, 1 Oct 2014 23:18:41 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH v2 0/8] mtd: nand: Support for new DT NAND driver
Message-ID: <20141002061841.GE3248@norris-Latitude-E6410>
References: <1408357919-19793-1-git-send-email-lee.jones@linaro.org>
 <20140819013729.GP18411@ld-irv-0074>
 <20140820065744.GE4266@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820065744.GE4266@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess I never answered this one:

On Wed, Aug 20, 2014 at 07:57:44AM +0100, Lee Jones wrote:
> On Mon, 18 Aug 2014, Brian Norris wrote:
> > Bisectability test results for configuration
> > "arm-multi_v7_defconfig,arm,arm-unknown-linux-gnueabi-" 
> > 
> > Failed to build patch #7: 5936df30f5e1 mtd: nand: stm_nand_bch: add
> > support for ST's BCH NAND controller 
> > Configuration: "arm-multi_v7_defconfig, architecture arm".
> 
> How do _you_ test for bisectability?  Do you have a script?
> 
> What outputs "Failed to build patch #7: ..."?

I use aiaiai [1]. But you could easily test bisectability without it.
e.g.

	#!/bin/sh
	for c in `git rev-list origin/master..HEAD`
	do
		git checkout $c
		make || break
	done

Brian

[1] http://lwn.net/Articles/488992/
    http://git.infradead.org/aiaiai.git
