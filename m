Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaHMMP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:15:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaHMMPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:15:25 -0400
Date: Wed, 13 Aug 2014 14:15:50 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Razya Ladelsky <razya@il.ibm.com>
Cc: abel.gordon@gmail.com, Alex Glikson <GLIKSON@il.ibm.com>,
        David Miller <davem@davemloft.net>,
        Eran Raichstein <ERANRA@il.ibm.com>, Joel Nider <JOELN@il.ibm.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Yossi Kuperman1 <YOSSIKU@il.ibm.com>
Subject: Re: [PATCH] vhost: Add polling mode
Message-ID: <20140813121550.GA21026@redhat.com>
References: <1407659404-razya@il.ibm.com>
 <20140810083035.0CF58380729@moren.haifa.ibm.com>
 <20140810194559.GA4344@redhat.com>
 <20140811.124621.576073630604147753.davem@davemloft.net>
 <20140812091850.GD6440@redhat.com>
 <OF93E480CE.EFA0854D-ONC2257D32.003BE092-C2257D32.003C1F49@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF93E480CE.EFA0854D-ONC2257D32.003BE092-C2257D32.003C1F49@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 01:57:05PM +0300, Razya Ladelsky wrote:
> "Michael S. Tsirkin" <mst@redhat.com> wrote on 12/08/2014 12:18:50 PM:
> 
> > From: "Michael S. Tsirkin" <mst@redhat.com>
> > To: David Miller <davem@davemloft.net>
> > Cc: Razya Ladelsky/Haifa/IBM@IBMIL, kvm@vger.kernel.org, Alex 
> > Glikson/Haifa/IBM@IBMIL, Eran Raichstein/Haifa/IBM@IBMIL, Yossi 
> > Kuperman1/Haifa/IBM@IBMIL, Joel Nider/Haifa/IBM@IBMIL, 
> > abel.gordon@gmail.com, linux-kernel@vger.kernel.org, 
> > netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
> > Date: 12/08/2014 12:18 PM
> > Subject: Re: [PATCH] vhost: Add polling mode
> > 
> > On Mon, Aug 11, 2014 at 12:46:21PM -0700, David Miller wrote:
> > > From: "Michael S. Tsirkin" <mst@redhat.com>
> > > Date: Sun, 10 Aug 2014 21:45:59 +0200
> > > 
> > > > On Sun, Aug 10, 2014 at 11:30:35AM +0300, Razya Ladelsky wrote:
> > >  ...
> > > > And, did your tests actually produce 100% load on both host CPUs?
> > >  ...
> > > 
> > > Michael, please do not quote an entire patch just to ask a one line
> > > question.
> > > 
> > > I truly, truly, wish it was simpler in modern email clients to delete
> > > the unrelated quoted material because I bet when people do this they
> > > are simply being lazy.
> > > 
> > > Thank you.
> > 
> > Lazy - mea culpa, though I'm using mutt so it isn't even hard.
> > 
> > The question still stands: the test results are only valid
> > if CPU was at 100% in all configurations.
> > This is the reason I generally prefer it when people report
> > throughput divided by CPU (power would be good too but it still
> > isn't easy for people to get that number).
> > 
> 
> Hi Michael,
> 
> Sorry for the delay, had some problems with my mailbox, and I realized 
> just now that 
> my reply wasn't sent.
> The vm indeed ALWAYS utilized 100% cpu, whether polling was enabled or 
> not.
> The vhost thread utilized less than 100% (of the other cpu) when polling 
> was disabled.
> Enabling polling increased its utilization to 100% (in which case both 
> cpus were 100% utilized). 

Hmm this means the testing wasn't successful then, as you said:

	The idea was to get it 100% loaded, so we can see that the polling is
	getting it to produce higher throughput.

in fact here you are producing more throughput but spending more power
to produce it, which can have any number of explanations besides polling
improving the efficiency. For example, increasing system load might
disable host power management.


> > -- 
> > MST
> > 
