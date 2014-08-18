Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaHRSlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:41:37 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39351 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHRSlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:41:35 -0400
Date: Mon, 18 Aug 2014 11:41:25 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: rydberg@euromail.se, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] evdev: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140818184125.GA31121@core.coreip.homeip.net>
References: <20140818144445.GA13933@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818144445.GA13933@ada>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreea,

On Mon, Aug 18, 2014 at 05:44:45PM +0300, Andreea-Cristina Bernat wrote:
> The use of "rcu_assign_pointer()" is NULLing out the pointer.
> According to RCU_INIT_POINTER()'s block comment:
> "1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
> it is better to use it instead of rcu_assign_pointer() because it has a
> smaller overhead.
> 
> The following Coccinelle semantic patch was used:
> @@
> @@
> 
> - rcu_assign_pointer
> + RCU_INIT_POINTER
>   (..., NULL)

The same objection as here: https://lkml.org/lkml/2014/3/23/96

Thanks.

-- 
Dmitry
