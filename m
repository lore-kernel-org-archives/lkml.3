Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaJZWfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 18:35:24 -0400
Received: from shell.v3.sk ([195.168.3.45]:44750 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbaJZWfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 18:35:22 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Oct 2014 18:35:22 EDT
Message-ID: <1414362511.29980.4.camel@belphegor.lan>
Subject: Re: [PATCH] ipv6: notify userspace when we added or changed an ipv6
 token
From: Lubomir Rintel <lkundrak@v3.sk>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Sun, 26 Oct 2014 23:28:31 +0100
In-Reply-To: <543B9F5A.8070909@redhat.com>
References: <1412950112-15593-1-git-send-email-lkundrak@v3.sk>
	 <543B9F5A.8070909@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 11:46 +0200, Daniel Borkmann wrote:
> On 10/10/2014 04:08 PM, Lubomir Rintel wrote:
> > NetworkManager might want to know that it changed when the router advertisement
> > arrives.
> >
> > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Cc: Daniel Borkmann <dborkman@redhat.com>
> > ---
> >   net/ipv6/addrconf.c | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > index 3e118df..3d11390 100644
> > --- a/net/ipv6/addrconf.c
> > +++ b/net/ipv6/addrconf.c
> > @@ -4528,6 +4528,7 @@ static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token)
> >   	}
> >
> >   	write_unlock_bh(&idev->lock);
> > +	netdev_state_change(dev);
> 
> I'm wondering why netdev_state_change()? You are probably
> only after the netlink notification that is being invoked,
> i.e. rtmsg_ifinfo(RTM_NEWLINK, ...), and don't strictly want
> to call the device notifier chain.

Correct. I'll change it to just rtmsg_ifinfo().

> Perhaps it might be better to define a new RTM_SETTOKEN, and
> just call inet6_ifinfo_notify(RTM_SETTOKEN, idev) as this is
> only idev specific anyway?

I'm not really sure as that would require more userspace changes than
necessary.

> >   	addrconf_verify_rtnl();
> >   	return 0;
> >   }
> >


