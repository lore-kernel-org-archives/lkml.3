Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965455Ab3FTMsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:48:01 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:63613 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965102Ab3FTMsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:48:00 -0400
Message-ID: <51C2F9FF.4090702@cogentembedded.com>
Date: Thu, 20 Jun 2013 16:47:59 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Asias He <asias@redhat.com>, Jason Wang <jasowang@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] vhost-net: fix use-after-free in vhost_net_flush
References: <20130620114813.GA17373@redhat.com>
In-Reply-To: <20130620114813.GA17373@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 20-06-2013 15:48, Michael S. Tsirkin wrote:

> vhost_net_ubuf_put_and_wait has a confusing name:
> it will actually also free it's argument.
> Thus since commit 1280c27f8e29acf4af2da914e80ec27c3dbd5c01

    Please also specify that commit's summary line in parens.

> vhost_net_flush tries to use the argument after passing it
> to vhost_net_ubuf_put_and_wait, this results
> in use after free.
> To fix, don't free the argument in vhost_net_ubuf_put_and_wait,
> add an new API for callers that want to free ubufs.

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

WBR, Sergei

