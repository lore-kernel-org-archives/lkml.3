Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaENFpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:45:47 -0400
Received: from 1wt.eu ([62.212.114.60]:35116 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaENFpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:45:43 -0400
Date: Wed, 14 May 2014 07:45:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [ 080/143] net: rework recvmsg handler msg_name and msg_namelen logic
Message-ID: <20140514054535.GA1562@1wt.eu>
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local> <20140512003203.962853843@1wt.eu> <20140513124425.GB4006@hercules>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513124425.GB4006@hercules>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

On Tue, May 13, 2014 at 01:44:25PM +0100, Luis Henriques wrote:
> On Mon, May 12, 2014 at 02:33:20AM +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > 
> > [ Upstream commit f3d3342602f8bcbf37d7c46641cb9bca7618eb1c ]
> > 
> 
> <snip>
> 
> > diff --git a/net/rxrpc/ar-recvmsg.c b/net/rxrpc/ar-recvmsg.c
> > index a39bf97..f779fc3 100644
> > --- a/net/rxrpc/ar-recvmsg.c
> > +++ b/net/rxrpc/ar-recvmsg.c
> > @@ -142,10 +142,12 @@ int rxrpc_recvmsg(struct kiocb *iocb, struct socket *sock,
> >  
> >  		/* copy the peer address and timestamp */
> >  		if (!continue_call) {
> > -			if (msg->msg_name && msg->msg_namelen > 0)
> > +			if (msg->msg_name) {
> > +				size_t len =
> > +					sizeof(call->conn->trans->peer->srx);
> >  				memcpy(msg->msg_name,
> > -				       &call->conn->trans->peer->srx,
> > -				       sizeof(call->conn->trans->peer->srx));
> > +				       &call->conn->trans->peer->srx, len);
>   +                                    msg->msg_namelen = len;
> 
> This statement^^^ is missing in this backport.
> 
> Also missing in this patch are the changes to the following functions:
> 
> - pppoe_recvmsg()
>   In file drivers/net/pppoe.c instead of drivers/net/ppp/pppoe.c
> 
> - pppol2tp_recvmsg()
>   In file drivers/net/pppol2tp.c instead of net/l2tp/l2tp_ppp.c
> 
> For reference, I'm attaching the backport we have used in our Ubuntu
> kernel.  (Note that we added some extra information to the commit
> message to include the CVE number and a link to the CVE bug.)

Just a quick note to let you know that your patch applied well, and
that the diff between the two correctly reports the parts you pointed
above. So I'm taking it instead.

Thanks!
Willy

