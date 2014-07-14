Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbaGNWIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:08:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36195 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaGNWIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:08:48 -0400
Date: Mon, 14 Jul 2014 15:08:47 -0700 (PDT)
Message-Id: <20140714.150847.1399242734159771901.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com,
        a.ryabinin@samsung.com
Subject: Re: net: socket: NULL ptr deref in sendmsg
From: David Miller <davem@davemloft.net>
In-Reply-To: <53C2FF3D.4030201@oracle.com>
References: <53C2FF3D.4030201@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Jul 2014 15:08:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Sun, 13 Jul 2014 17:50:53 -0400

> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel with the KASAN patchset, I've stumbled on the following spew:
 ...
> It's similar to another variation:
 ...
> I've tried debugging it, but I don't see a code path that could lead to that.

Both of these cases involve working with pointers declared with
DECLARE_SOCKADDR, maybe that somehow confuses ASAN code generation?
