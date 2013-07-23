Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab3GWPRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:17:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51164 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620Ab3GWPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:17:31 -0400
Date: Tue, 23 Jul 2013 08:17:27 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Basil Gor <basil.gor@gmail.com>
Subject: Re: [PATCH net-next] tuntap: hardware vlan tx support
Message-ID: <20130723081727.69766d27@nehalam.linuxnetplumber.net>
In-Reply-To: <1374563748-38821-1-git-send-email-jasowang@redhat.com>
References: <1374563748-38821-1-git-send-email-jasowang@redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013 15:15:48 +0800
Jason Wang <jasowang@redhat.com> wrote:

> Inspired by commit f09e2249c4f5c7c13261ec73f5a7807076af0c8e (macvtap: restore
> vlan header on user read). This patch adds hardware vlan tx support for
> tuntap. This is done by copying vlan header directly into userspace in
> tun_put_user() instead of doing it through __vlan_put_tag() in
> dev_hard_start_xmit(). This eliminates one unnecessary memove in
> vlan_insert_tag() for 802.1ad and 802.1q traffic.
> 
> pktgen test shows about 20% improvement for 802.1q traffic:
> 
> Before:
>   662149pps 317Mb/sec (317831520bps) errors: 0
> After:
>   801033pps 384Mb/sec (384495840bps) errors: 0
> 
> Cc: Basil Gor <basil.gor@gmail.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>


You need to make this configurable by some mechanism, since otherwise
it will break applications that expect current VLAN behavior
