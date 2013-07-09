Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab3GIT42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 15:56:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58941 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab3GIT4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 15:56:25 -0400
Date: Tue, 09 Jul 2013 12:56:24 -0700 (PDT)
Message-Id: <20130709.125624.1456063645210971879.davem@davemloft.net>
To: mst@redhat.com
Cc: asias@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] vhost-net: fix use-after-free in vhost_net_flush
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130707112653.GA31232@redhat.com>
References: <20130707112653.GA31232@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 7 Jul 2013 14:26:53 +0300

> vhost_net_ubuf_put_and_wait has a confusing name:
> it will actually also free it's argument.
> Thus since commit 1280c27f8e29acf4af2da914e80ec27c3dbd5c01
>     "vhost-net: flush outstanding DMAs on memory change"
> vhost_net_flush tries to use the argument after passing it
> to vhost_net_ubuf_put_and_wait, this results
> in use after free.
> To fix, don't free the argument in vhost_net_ubuf_put_and_wait,
> add an new API for callers that want to free ubufs.
> 
> Acked-by: Asias He <asias@redhat.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied and queued up for -stable.
