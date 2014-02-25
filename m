Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaBYFhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 00:37:39 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46930 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaBYFhh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 00:37:37 -0500
From: Florian Fainelli <f.fainelli@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: ben@decadent.org.uk, mcgrof@do-not-panic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcgrof@suse.com
Subject: Re: [PATCH] net: kdoc struct net_device flags and priv_flags
Date: Mon, 24 Feb 2014 21:37:34 -0800
Message-ID: <2446186.I4KkJ8Hjdb@lenovo>
User-Agent: KMail/4.11.5 (Linux/3.11.0-17-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140224.235343.1936318499491821387.davem@davemloft.net>
References: <1393287245-4549-1-git-send-email-mcgrof@do-not-panic.com> <1393294265.6823.154.camel@deadeye.wl.decadent.org.uk> <20140224.235343.1936318499491821387.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 24 février 2014, 23:53:43 David Miller a écrit :
> From: Ben Hutchings <ben@decadent.org.uk>
> Date: Tue, 25 Feb 2014 02:11:05 +0000
> 
> > On Mon, 2014-02-24 at 16:14 -0800, Luis R. Rodriguez wrote:
> >> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >> 
> >> ---
> >> 
> >>  include/uapi/linux/if.h | 201
> >>  +++++++++++++++++++++++++++++++++++------------- 1 file changed, 149
> >>  insertions(+), 52 deletions(-)
> >> 
> >> diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
> >> index d758163..1555623 100644
> >> --- a/include/uapi/linux/if.h
> >> +++ b/include/uapi/linux/if.h
> > 
> > [...]
> > 
> >> +/**
> >> + * enum net_device_priv_flags - &struct net_device priv_flags
> >> + *
> >> + * These are the &struct net_device, they are only set internally
> >> + * by drivers and used in the kernel but are invisible to userspace.
> > 
> > [...]
> > 
> > Indeed, I wonder why they are in the UAPI header.  As userland doesn't
> > have a legitimate use for them, maybe you could move them back to
> > include/linux/if.h instead of bothering with adding macros?
> 
> They are visible to userspace via sysfs.

In /sys/class/net/*/flags, although we are lacking quite a lot of documentation 
for the exported attributes there.

The only attributes for which there is some sort of documentation are 
"operstate" and the XPS/RFS/RPS attributes, maybe that could be fixed too as 
part of this documentation patch?

> 
> My memory may be bad, but I believe this has been brought up before.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Florian
