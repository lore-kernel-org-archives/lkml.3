Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab3FZAM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 20:12:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35393 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3FZAM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 20:12:56 -0400
Date: Tue, 25 Jun 2013 17:12:55 -0700 (PDT)
Message-Id: <20130625.171255.708823220529825023.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, asias@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCHv2] vhost-net: fix use-after-free in vhost_net_flush
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130625142946.GA17414@redhat.com>
References: <20130625142946.GA17414@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 25 Jun 2013 17:29:46 +0300

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

This doesn't apply cleanly to the 'net' tree, please fix this up
and resubmit.

Thanks.
