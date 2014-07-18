Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbaGRIS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:18:28 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48795 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbaGRISV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:18:21 -0400
Date: Fri, 18 Jul 2014 10:18:12 +0200
From: Alexander Aring <alex.aring@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: teg@jklm.no, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net
Subject: Re: [Linux-zigbee-devel] [PATCH net-next v9 3/9] net: nl802154 -
 make add_iface take name assign type
Message-ID: <20140718081810.GA6555@omega>
References: <1405584370-30054-1-git-send-email-teg@jklm.no>
 <1405584370-30054-4-git-send-email-teg@jklm.no>
 <20140717.161931.283488873926282207.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140717.161931.283488873926282207.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 04:19:31PM -0700, David Miller wrote:
> From: Tom Gundersen <teg@jklm.no>
> Date: Thu, 17 Jul 2014 10:06:04 +0200
> 
> > @@ -192,8 +193,10 @@ int ieee802154_add_iface(struct sk_buff *skb, struct genl_info *info)
> >  		if (devname[nla_len(info->attrs[IEEE802154_ATTR_DEV_NAME]) - 1]
> >  				!= '\0')
> >  			return -EINVAL; /* phy name should be null-terminated */
> > +		name_assign_type = NET_NAME_USER;
> >  	} else  {
> >  		devname = "wpan%d";
> > +		name_assign_type = NET_NAME_ENUM;
> >  	}
> >  
> >  	if (strlen(devname) >= IFNAMSIZ)
> 
> Just wondering what should happen if "%d" appears in a user provided name.
> 

I tested it. If I use a name like "foobar%d" then I get a foobar0,
foobar1 ... foobarX.

> That would seem to be both USER and ENUM.
> 

yes.


- Alex
