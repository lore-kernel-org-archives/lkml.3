Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab3DYIWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:22:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49982 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab3DYIWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:22:44 -0400
Date: Thu, 25 Apr 2013 04:22:43 -0400 (EDT)
Message-Id: <20130425.042243.666546906391472969.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: acking@vmware.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VSOCK: Drop bogus __init annotation from
 vsock_init_tables()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1366796455-2520-1-git-send-email-geert@linux-m68k.org>
References: <1366796455-2520-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 25 Apr 2013 01:22:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 24 Apr 2013 11:40:55 +0200

> If gcc (e.g. 4.1.2) decides not to inline vsock_init_tables(), this will
> cause a section mismatch:
> 
> WARNING: net/vmw_vsock/vsock.o(.text+0x1bc): Section mismatch in reference from the function __vsock_core_init() to the function .init.text:vsock_init_tables()
> The function __vsock_core_init() references
> the function __init vsock_init_tables().
> This is often because __vsock_core_init lacks a __init
> annotation or the annotation of vsock_init_tables is wrong.
> 
> This may cause crashes if VSOCKETS=y and VMWARE_VMCI_VSOCKETS=m.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
