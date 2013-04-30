Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab3D3AvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:51:06 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48660 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165Ab3D3AvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:51:04 -0400
Message-ID: <1367283060.8964.336.camel@edumazet-glaptop>
Subject: Re: [PATCH v3 3/3] unix/stream: fix peeking with an offset larger
 than data in queue
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Apr 2013 17:51:00 -0700
In-Reply-To: <1367271734-14379-3-git-send-email-bpoirier@suse.de>
References: <kll5si$544$1@ger.gmane.org>
	 <1367271734-14379-1-git-send-email-bpoirier@suse.de>
	 <1367271734-14379-3-git-send-email-bpoirier@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 17:42 -0400, Benjamin Poirier wrote:
> Currently, peeking on a unix stream socket with an offset larger than len of
> the data in the sk receive queue returns immediately with bogus data.
> 
> This patch fixes this so that the behavior is the same as peeking with no
> offset on an empty queue: the caller blocks.
> 
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
> ---
>  net/unix/af_unix.c |   25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)

Acked-by: Eric Dumazet <edumazet@google.com>


