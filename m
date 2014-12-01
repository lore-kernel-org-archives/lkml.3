Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaLAMaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:30:22 -0500
Received: from 1wt.eu ([62.212.114.60]:27440 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbaLAMaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:30:20 -0500
Date: Mon, 1 Dec 2014 13:30:07 +0100
From: Willy Tarreau <w@1wt.eu>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 22/48] net: sendmsg: fix NULL pointer dereference
Message-ID: <20141201123007.GB7949@1wt.eu>
References: <28c765bc23bd4bae1611534e510f49f8@local> <20141116215329.569150542@1wt.eu> <20141201114522.GC6874@hercules>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201114522.GC6874@hercules>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

On Mon, Dec 01, 2014 at 11:45:22AM +0000, Luis Henriques wrote:
> > diff --git a/net/compat.c b/net/compat.c
> > index e9672c8..71ed839 100644
> > --- a/net/compat.c
> > +++ b/net/compat.c
> > @@ -83,7 +83,7 @@ int verify_compat_iovec(struct msghdr *kern_msg, struct iovec *kern_iov,
> >  {
> >  	int tot_len;
> >  
> > -	if (kern_msg->msg_namelen) {
> > +	if (kern_msg->msg_namelen && kern_msg->msg_namelen) {
> 
> I know my review is already too late for the release,

No problem, there's no deadline for reporting bugs :-)

> but the above
> line isn't correct -- it's checking msg_namelen twice, instead of
> checking msg_name as well:
> 
> 	if (kern_msg->msg_name && kern_msg->msg_namelen)

Woops! I must have failed it by myself while doing it by hand :-(

Queuing the fix now, thank s for reporting!
Willy

