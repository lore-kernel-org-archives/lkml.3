Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab3LYSd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 13:33:59 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:65198 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3LYSd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 13:33:57 -0500
MIME-Version: 1.0
In-Reply-To: <1387983339-1172-2-git-send-email-mst@redhat.com>
References: <1387983339-1172-1-git-send-email-mst@redhat.com> <1387983339-1172-2-git-send-email-mst@redhat.com>
From: Michael Dalton <mwdalton@google.com>
Date: Wed, 25 Dec 2013 10:33:37 -0800
Message-ID: <CANJ5vPK-rs2d_TvZ3wuAXMK8ctoSvg2km8MpncMU+0cdk=TAsw@mail.gmail.com>
Subject: Re: [PATCH stable 1/2] virtio_net: fix error handling for mergeable buffers
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Eric Dumazet <edumazet@google.com>, Jason Wang <jasowang@redhat.com>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael, quick question below:

On Wed, Dec 25, 2013 at 6:56 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
>                 if (i >= MAX_SKB_FRAGS) {
>                         pr_debug("%s: packet too long\n", skb->dev->name);
>                         skb->dev->stats.rx_length_errors++;
> -                       return -EINVAL;
> +                       return NULL;
>                 }

Should this error handling path free the SKB before returning NULL?
It seems like if we just return NULL we may leak memory.

Best,

Mike
