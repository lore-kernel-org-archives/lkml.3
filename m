Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaKRTxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:53:30 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:35898 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbaKRTx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:53:29 -0500
MIME-Version: 1.0
In-Reply-To: <1416288041-30921-1-git-send-email-jasowang@redhat.com>
References: <1416288041-30921-1-git-send-email-jasowang@redhat.com>
Date: Tue, 18 Nov 2014 11:53:28 -0800
Message-ID: <CAHA+R7O=vCtLwUPnkVpymxc9kp+a8ChS2MHAJahfJUNUdLX89A@mail.gmail.com>
Subject: Re: [PATCH net-next] tun: return NET_XMIT_DROP for dropped packets
From: Cong Wang <cwang@twopensource.com>
To: Jason Wang <jasowang@redhat.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 9:20 PM, Jason Wang <jasowang@redhat.com> wrote:
> After commit 5d097109257c03a71845729f8db6b5770c4bbedc
> ("tun: only queue packets on device"), NETDEV_TX_OK was returned for
> dropped packets. This will confuse pktgen since dropped packets were
> counted as sent ones.
>
> Fixing this by returning NET_XMIT_DROP to let pktgen count it as error
> packet.

pktgen is suspicious, it sends out packets directly without going through
qdisc, so it should not care about NET_XMIT_* qdisc error code?

Looks like NETDEV_TX_OK doesn't have to mean TX is successful,
the comment says driver takes care of the packet, can be either dropped
or sent out. We might need a new code to distinguish success or failure.
