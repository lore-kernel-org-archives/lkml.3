Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaELIuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:50:08 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:47086 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbaELIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:50:04 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2014 04:50:04 EDT
Date: Mon, 12 May 2014 10:41:06 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 030/143] proc connector: fix info leaks
Message-ID: <1399883822@msgid.manchmal.in-ulm.de>
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
 <20140512003201.879931356@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512003201.879931356@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote...

> Initialize event_data for all possible message types to prevent leaking
> kernel stack contents to userland (up to 20 bytes). Also set the flags
> member of the connector message to 0 to prevent leaking two more stack
> bytes this way.

There are build errors as shown below and I guess that one is the
culprit. Can do detailled checks tonight, I'm a bit in a hurry right
now.

(Using gcc-4.7 as provided by Debian wheezy)

    Christoph

drivers/connector/cn_proc.c:286:9: error: expected declaration specifiers or '...' before '&' token
drivers/connector/cn_proc.c:286:26: error: expected declaration specifiers or '...' before numeric constant
drivers/connector/cn_proc.c:286:29: error: expected declaration specifiers or '...' before 'sizeof'
drivers/connector/cn_proc.c:287:5: error: expected '=', ',', ';', 'asm' or '__attribute__' before '->' token
make[5]: *** [drivers/connector/cn_proc.o] Error 1
make[4]: *** [drivers/connector] Error 2
make[4]: *** Waiting for unfinished jobs....
