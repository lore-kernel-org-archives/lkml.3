Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaCMWQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:16:31 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33317 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaCMWQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:16:29 -0400
Date: Thu, 13 Mar 2014 15:16:23 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, mcgrof@suse.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH 3/3] bridge: fix bridge root block on designated port
Message-ID: <20140313151623.03e0484d@nehalam.linuxnetplumber.net>
In-Reply-To: <1394680527-28970-4-git-send-email-mcgrof@do-not-panic.com>
References: <1394680527-28970-1-git-send-email-mcgrof@do-not-panic.com>
	<1394680527-28970-4-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 20:15:27 -0700
"Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:

> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -150,6 +150,7 @@ struct net_bridge_port
>  	u8				priority;
>  	u8				state;
>  	u16				port_no;
> +	bool				root_block_enabled;
>  	unsigned char			topology_change_ack;

It seems a bit confusing to have both a ROOT_BLOCK flag in the
data structure and and additional root_block_enabled flag.
If nothing else it is a waste of space.

Looks like you are changing the meaning slightly. is possible
to have BR_ROOT_BLOCK set but !root_block_enabled? and what about
the inverse?
