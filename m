Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650Ab3LIHc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 02:32:56 -0500
Received: from relay.parallels.com ([195.214.232.42]:57763 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3LIHcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 02:32:54 -0500
Message-ID: <52A5721E.6020709@parallels.com>
Date: Mon, 9 Dec 2013 11:32:46 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: <davem@davemloft.net>, <edumazet@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: unix: allow set_peek_off to fail
References: <1386455187-28597-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1386455187-28597-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2013 02:26 AM, Sasha Levin wrote:
> unix_dgram_recvmsg() will hold the readlock of the socket until recv
> is complete.
> 
> In the same time, we may try to setsockopt(SO_PEEK_OFF) which will hang until
> unix_dgram_recvmsg() will complete (which can take a while) without allowing
> us to break out of it, triggering a hung task spew.
> 
> Instead, allow set_peek_off to fail, this way userspace will not hang.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Acked-by: Pavel Emelyanov <xemul@parallels.com>
