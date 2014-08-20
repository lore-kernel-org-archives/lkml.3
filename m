Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaHTK6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 06:58:22 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55559 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaHTK6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 06:58:21 -0400
Date: Wed, 20 Aug 2014 12:58:17 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Pankaj Gupta <pagupta@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        jasowang@redhat.com, mst@redhat.com, dgibson@redhat.com,
        vfalico@gmail.com, edumazet@google.com, vyasevic@redhat.com,
        hkchu@google.com, wuzhy@linux.vnet.ibm.com, xemul@parallels.com,
        therbert@google.com, bhutchings@solarflare.com, xii@google.com,
        stephen@networkplumber.org
Subject: Re: [RFC 2/4] tuntap: Publish tuntap maximum number of queues as
 module_param
Message-ID: <20140820105817.GB1916@nanopsycho.orion>
References: <1408369040-1216-1-git-send-email-pagupta@redhat.com>
 <1408369040-1216-3-git-send-email-pagupta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408369040-1216-3-git-send-email-pagupta@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mon, Aug 18, 2014 at 03:37:18PM CEST, pagupta@redhat.com wrote:
> This patch publishes maximum number of tun/tap queues allocated as a
> read_only module parameter which a user space application like libvirt
> can make use of to limit maximum number of queues. Value of read_only
> module parameter can be writable only at module load time. If no value is set
> at module load time a default value 256 is used which is equal to maximum number
> of vCPUS allowed by KVM.
>
> Administrator can specify maximum number of queues only at the driver
> module load time.
>
>Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
>---
> drivers/net/tun.c |   13 +++++++++++--
> 1 files changed, 11 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>index acaaf67..1f518e2 100644
>--- a/drivers/net/tun.c
>+++ b/drivers/net/tun.c
>@@ -119,6 +119,9 @@ struct tap_filter {
> 
> #define TUN_FLOW_EXPIRE (3 * HZ)
> 
>+static int max_tap_queues = MAX_TAP_QUEUES;
>+module_param(max_tap_queues, int, S_IRUGO);

Please do not introduce new module paramaters. Please other ways to
interchange values with userspace.
