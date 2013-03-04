Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab3CDQQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 11:16:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44155 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758458Ab3CDQQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 11:16:05 -0500
Message-ID: <1362413759.15793.98.camel@edumazet-glaptop>
Subject: Re: [RFC PATCH 1/5] net: implement support for low latency socket
 polling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Mon, 04 Mar 2013 08:15:59 -0800
In-Reply-To: <5134BD9B.2080003@linux.intel.com>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
	   <20130227175555.10611.42794.stgit@gitlad.jf.intel.com>
	  <1362335704.15793.81.camel@edumazet-glaptop>
	  <51345EB8.9050309@linux.intel.com>
	 <1362408768.15793.89.camel@edumazet-glaptop>
	 <5134BD9B.2080003@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-04 at 17:28 +0200, Eliezer Tamir wrote:
> On 04/03/2013 16:52, Eric Dumazet wrote:
> > On Mon, 2013-03-04 at 10:43 +0200, Eliezer Tamir wrote:
> >
> >> One could for example increment the generation id every time the RTNL is
> >> taken. or is this too much?
> >
> > RTNL is taken for a lot of operations, it would be better to have a
> > finer grained increment.
> 
> If is taken rarely enough it will still be worth it.
> 

Yes, but eventually it makes attempts to get rid of RTNL a nightmare.

When adding new network features, just use the right semantic from the
beginning.

> Otherwise it may be hard to know what operations need to invalidate the 
> napi reference. It can very well be HW dependent, and then you end up 
> adding a function for drivers to call to do the invalidation.
> 
> Or we can decide that we only care about catastrophic events and only 
> worry about a napi completely going away and not worry about 
> configuration changes.(Polling the wrong queue will not kill you, it's 
> just a waste of perfectly good CPU cycles.)

As long as the incoming packets are able to update the information, who
cares if one packet missed the poll ?
 


