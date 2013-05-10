Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab3EJTgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 15:36:08 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:47667 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3EJTgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 15:36:05 -0400
Date: Fri, 10 May 2013 11:46:25 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rodolfo Giometti <giometti@linux.it>
Subject: Re: linux-next: Tree for May 7 (bq27x00_battery)
Message-ID: <20130510184625.GA2602@teo>
References: <20130507134922.981483ab1e5cb09e5543a6cc@canb.auug.org.au>
 <51893811.8080102@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51893811.8080102@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 10:21:21AM -0700, Randy Dunlap wrote:
> On 05/06/13 20:49, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Please do not add any v3.11 destined work to your linux-next included
> > branches until after v3.10-rc1 is released.
> > 
> > I am receiving a (un)reasonable number of conflicts from there being
> > multiple copies of some commits in various trees.   Please clean this up
> > and resist the temptataion to rebase your trees on the way to your
> > upstream ...
> > 
> > Changes since 20130506:
> > 
> 
> on x86_64:
> 
> drivers/built-in.o: In function `bq27x00_read_i2c':
> bq27x00_battery.c:(.text+0x169e20): undefined reference to `i2c_transfer'
> bq27x00_battery.c:(.text+0x169e44): undefined reference to `i2c_transfer'
> drivers/built-in.o: In function `bq27x00_battery_init':
> bq27x00_battery.c:(.init.text+0x82af): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `bq27x00_battery_exit':
> bq27x00_battery.c:(.exit.text+0xd8f): undefined reference to `i2c_del_driver'
> 
> 
> when CONFIG_I2C=m and CONFIG_BATTERY_BQ27X00_I2C=y.

Thanks for the report! This should be fixed by this commit:

commit a2d0dbb4b55681874c5f288538ae55ae69baeaff
Author: Xiong Zhou <jencce.kernel@gmail.com>
Date:   Tue May 7 10:15:56 2013 +0800

    bq27x00: Fix I2C dependency in KConfig
