Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbaLEETn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 23:19:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49508 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbaLEETl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 23:19:41 -0500
Date: Thu, 04 Dec 2014 20:24:04 -0800 (PST)
Message-Id: <20141204.202404.32587724475591669.davem@davemloft.net>
To: mail@rupran.de
Cc: jim.epost@gmail.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiri@resnulli.us, sfeldma@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: rocker: Add select to CONFIG_BRIDGE in
 Kconfig
From: David Miller <davem@davemloft.net>
In-Reply-To: <54809BA5.7030901@rupran.de>
References: <CA+r1ZhhJQuwXbs+Et-ihsGP3QXDUWZ1nJ-5_hcjioFt5s8zMrA@mail.gmail.com>
	<54809BA5.7030901@rupran.de>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Dec 2014 20:19:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Ruprecht <mail@rupran.de>
Date: Thu, 04 Dec 2014 18:36:37 +0100

> On 04.12.2014 17:34, Jim Davis wrote:
>> Building with the attached random configuration file,
>> 
>> drivers/built-in.o: In function `rocker_port_fdb_learn_work':
>> /home/jim/linux/drivers/net/ethernet/rocker/rocker.c:3014: undefined
>> reference to `br_fdb_external_learn_del'
>> /home/jim/linux/drivers/net/ethernet/rocker/rocker.c:3016: undefined
>> reference to `br_fdb_external_learn_add'
>> 
> 
> Hi,
> 
> the problem here is that CONFIG_BRIDGE is set to 'm' (leading to
> inclusion of the two functions above in the kernel module) while
> CONFIG_ROCKER is set to 'y', requiring the functions at link time.
> 
> Is the attached patch sufficient to fix this?

Do not use select, please.

You can only use select on leaf node Kconfig symbols, ie. those
which do not have any dependencies whatsoever.

Select does not recursively walk down the dependency chain turning
things on for you when you say "select X".
