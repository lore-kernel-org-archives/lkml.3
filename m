Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935726Ab3DITFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:05:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37981 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762470Ab3DITFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:05:47 -0400
Date: Tue, 09 Apr 2013 15:05:43 -0400 (EDT)
Message-Id: <20130409.150543.466468818028967750.davem@davemloft.net>
To: keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        minipli@googlemail.com, spender@grsecurity.net
Subject: Re: [PATCH] net: pre-clear the returned sockaddr_storage variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130409175024.GA19308@www.outflux.net>
References: <20130409175024.GA19308@www.outflux.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 09 Apr 2013 12:05:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Tue, 9 Apr 2013 10:50:24 -0700

> To avoid future stack content leaks in the various protocols, pre-clear
> the returned memory.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Suggested-by: Brad Spengler <spender@grsecurity.net>

No thanks, clearing 2 full cache lines unnecessarily on every socket
call has real cost.
