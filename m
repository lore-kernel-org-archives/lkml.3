Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab3KRNm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:42:28 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33415 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3KRNmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:42:20 -0500
Date: Mon, 18 Nov 2013 13:42:11 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Heorhi Valakhanovich <valahanovich@tut.by>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] tty: Only hangup once
Message-ID: <20131118134211.17861db3@alan.etchedpixels.co.uk>
In-Reply-To: <20131117203850.46df2124@tormoz-pc>
References: <1375293945-4087-1-git-send-email-peter@hurleysoftware.com>
	<20131117203850.46df2124@tormoz-pc>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After upgrading to kernel 3.12 I noticed one issue with tmux software.
> The easiest way to reproduce will be:
> 1. Start tmux session as root.
> 2. Connect via ssh and use "tmux attach" to attach to the running
> session.
> 3. Kill ssh client.
> 
> You can notice that shell (zsh in my case) and "tmux attach" are still
> remains in process' list. That didn't happen in previous kernels.
> I've tried to bisect this in kernel sources and found commit
> cb50e5235b8ae5aa0fe422eaaa8e444024c5bd98 which contains this exact
> patch. I have not enough experience to investigate more so most likely
> I will not find anything more. But it will be good if someone more
> experienced will have a look at it.

The patch should be reverted. The submission gives no reason that the
patch was required - it just adds code and optimises a path that doesn't
need optimising anyway.

It's theoretically true you only need one hangup, unfortunately however
I think it has to be the *last* hangup not the first or there are races
between the tty code and the process group handling.

Alan
