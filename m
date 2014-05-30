Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbaE3Oc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:32:29 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62944 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbaE3Oc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:32:28 -0400
Date: Fri, 30 May 2014 07:32:24 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Jon Maxwell <jmaxwell37@gmail.com>
Cc: davem@davemloft.net, makita.toshiaki@lab.ntt.co.jp, vyasevic@redhat.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpirko@redhat.com, jmaxwell@redhat.com
Subject: Re: [PATCH net] bridge: notify user space after fdb update
Message-ID: <20140530073224.2d0baa37@nehalam.linuxnetplumber.net>
In-Reply-To: <1401348436-5187-1-git-send-email-jmaxwell37@gmail.com>
References: <1401348436-5187-1-git-send-email-jmaxwell37@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014 17:27:16 +1000
Jon Maxwell <jmaxwell37@gmail.com> wrote:

> There has been a number incidents recently where customers running KVM have
> reported that VM hosts on different Hypervisors are unreachable. Based on
> pcap traces we found that the bridge was broadcasting the ARP request out
> onto the network. However some NICs have an inbuilt switch which on occasions
> were broadcasting the VMs ARP request back through the physical NIC on the
> Hypervisor. This resulted in the bridge changing ports and incorrectly learning
> that the VMs mac address was external. As a result the ARP reply was directed
> back onto the external network and VM never updated it's ARP cache. This patch
> will notify the bridge command, after a fdb has been updated to identify such
> port toggling.
> 
> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
