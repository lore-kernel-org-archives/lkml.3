Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbaCMS02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:26:28 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:38633 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbaCMS00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:26:26 -0400
MIME-Version: 1.0
In-Reply-To: <1394680527-28970-3-git-send-email-mcgrof@do-not-panic.com>
References: <1394680527-28970-1-git-send-email-mcgrof@do-not-panic.com>
	<1394680527-28970-3-git-send-email-mcgrof@do-not-panic.com>
Date: Thu, 13 Mar 2014 11:26:25 -0700
Message-ID: <CAHA+R7Pf6rM5h1uGiqrru5LkN9C7Nm7V42cucHSOV1s7_+F7Gw@mail.gmail.com>
Subject: Re: [PATCH 2/3] bridge: trigger a bridge calculation upon port changes
From: Cong Wang <cwang@twopensource.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org, mcgrof@suse.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 8:15 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
>                         spin_lock_bh(&p->br->lock);
>                         err = br_setport(p, tb);
> +                       changed = br_stp_recalculate_bridge_id(p->br);

Looks like you only want to check if the mac addr gets changed here,
but br_stp_recalculate_bridge_id() does more than just checking it,
are you sure the side-effects are all what you want here?

>                         spin_unlock_bh(&p->br->lock);
> +                       if (changed)
> +                               call_netdevice_notifiers(NETDEV_CHANGEADDR,
> +                                                        p->br->dev);
> +                       netdev_update_features(p->br->dev);

I think this is supposed to be in netdev event handler of br->dev
instead of here.
