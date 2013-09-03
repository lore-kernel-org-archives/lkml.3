Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab3ICD2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 23:28:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41724 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272Ab3ICD1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 23:27:54 -0400
Date: Mon, 02 Sep 2013 20:33:55 -0700 (PDT)
Message-Id: <20130902.203355.117341085023152754.davem@davemloft.net>
To: dhowells@redhat.com
Cc: cl@linux.com, tj@kernel.org, akpm@linuxfoundation.org,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [guv v2 04/31] net: Replace __get_cpu_var uses
From: David Miller <davem@davemloft.net>
In-Reply-To: <7435.1378157706@warthog.procyon.org.uk>
References: <00000140bc5ef9df-d7f75909-a25e-4471-84b2-dfbec07117b0-000000@email.amazonses.com>
	<20130826204351.725357339@linux.com>
	<7435.1378157706@warthog.procyon.org.uk>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 02 Sep 2013 20:27:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Mon, 02 Sep 2013 22:35:06 +0100

> Would it be possible to use __thread annotations for per-CPU
> variables, I wonder?

Paul Mackerras tried it on powerpc and you can't do it.

The problem is that there is no way to tell the compiler that sched()
and similar (potentially) change the thread pointer base.

It really will cache pre-computed __thread pointer calculations across
sched().
