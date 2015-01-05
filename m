Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbbAEDXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 22:23:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45964 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbbAEDXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 22:23:15 -0500
Date: Sun, 04 Jan 2015 22:23:13 -0500 (EST)
Message-Id: <20150104.222313.844590125087915248.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, perex@perex.cz, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] hp100: simplify hp100_module_init
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420292656-14429-1-git-send-email-fabf@skynet.be>
References: <1420292656-14429-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 04 Jan 2015 19:23:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Sat,  3 Jan 2015 14:44:16 +0100

> -Avoid double goto and directly return err where possible.
> -Remove unused labels which fixes:
> 
> drivers/net/ethernet/hp/hp100.c:3047:2: warning: label
> 'out3' defined but not used [-Wunused-label]
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> This is untested.

Having a sole lone return statement that all flows of control
branch to makes the code easier to audit, than to have a huge
block where each return statement has to be audited independently
for potential cleanups.

Added to the fact that this patch is completely untested, I'm
not applying this, sorry.
