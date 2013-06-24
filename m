Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3FXLbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:31:21 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59435 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3FXLbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:31:19 -0400
Date: Mon, 24 Jun 2013 07:31:13 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org, Brad Hubbard <bhubbard@redhat.com>
Subject: Re: [PATCH net] tun: fix recovery from gup errors
Message-ID: <20130624113113.GA25233@hmsreliant.think-freely.org>
References: <20130623141903.GA21029@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623141903.GA21029@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 05:19:03PM +0300, Michael S. Tsirkin wrote:
> get user pages might fail partially in tun zero copy
> mode. To recover we need to put all pages that we got,
> but code used a wrong index resulting in double-free
> errors.
> 
> Reported-by: Brad Hubbard <bhubbard@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> I haven't figured out why do we get failures,
> but recovery is clearly wrong.
> 
> This is also -stable material.
> 
>  drivers/net/tun.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

