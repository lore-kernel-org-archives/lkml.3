Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbaGPCo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 22:44:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbaGPCoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 22:44:54 -0400
Message-ID: <53C5E71E.7050706@redhat.com>
Date: Wed, 16 Jul 2014 10:44:46 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevic@redhat.com>
Subject: Re: [PATCH net-next] virtio-net: rx busy polling support
References: <1405417265-13103-1-git-send-email-jasowang@redhat.com> <1405419703.10255.26.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1405419703.10255.26.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 06:21 PM, Eric Dumazet wrote:
> On Tue, 2014-07-15 at 17:41 +0800, Jason Wang wrote:
>> Add basic support for rx busy polling.
>>
>> 1 byte netperf tcp_rr on mlx4 shows 116% improvement: the transaction
>> rate was increased from 9151.94 to 19787.37.
> This is a misleading changelog.
>
> You forgot to describe how you allowed busy polling, as it is not
> 'automatic'
>
> If not, this patch adds two spinlock/unlock pairs in fast path.

Ok.
> Also, it looks like you could split this in smaller patches.
>
> virtnet_napi_disable_all() & virtnet_napi_enable_all() could be added in
> a separate patch for example.

Sure, will split this patch into smaller ones in V2.

Thanks
