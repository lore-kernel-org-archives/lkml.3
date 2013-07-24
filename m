Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3GXPLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:11:46 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64698 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3GXPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:11:44 -0400
Date: Wed, 24 Jul 2013 08:11:39 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Basil Gor <basil.gor@gmail.com>
Subject: Re: [PATCH net-next] tuntap: hardware vlan tx support
Message-ID: <20130724081139.28ba3429@nehalam.linuxnetplumber.net>
In-Reply-To: <51EF6C42.1070304@redhat.com>
References: <1374563748-38821-1-git-send-email-jasowang@redhat.com>
	<20130723085310.4a036a47@nehalam.linuxnetplumber.net>
	<51EF6C42.1070304@redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jul 2013 13:55:14 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 07/23/2013 11:53 PM, Stephen Hemminger wrote:
> > On Tue, 23 Jul 2013 15:15:48 +0800
> > Jason Wang <jasowang@redhat.com> wrote:
> >
> >> +		struct {
> >> +			__be16 h_vlan_proto;
> >> +			__be16 h_vlan_TCI;
> >> +		} veth;
> > Don't you want to use struct vlan_hdr here? 
> 
> There's no need to care encapsulated proto here. In fact, we just
> emulate the hardware inserting of 802.1Q header. So only skb->vlan_tci
> and skb->vlan_proto needs to be cared.
> > Your definition puts the two fields out of order?
> 
> It's order is same as struct vlan_ethhdr. Did you see any issue?

I was looking at if_vlan.h struct vlan_hdr. The veth structure
is a slice between ether and vlan header.
