Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaLAPSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:18:24 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:54468 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaLAPSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:18:22 -0500
Date: Mon, 1 Dec 2014 16:18:13 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 36/46] vhost/net: suppress compiler warning
Message-ID: <20141201161813.7d0820c7.cornelia.huck@de.ibm.com>
In-Reply-To: <20141201151208.GA18919@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-37-git-send-email-mst@redhat.com>
	<20141201133740.56d7d6d8.cornelia.huck@de.ibm.com>
	<20141201134839.GB18305@redhat.com>
	<20141201152103.0f375544.cornelia.huck@de.ibm.com>
	<20141201151208.GA18919@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120115-0041-0000-0000-00000251BEB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 17:12:08 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Dec 01, 2014 at 03:21:03PM +0100, Cornelia Huck wrote:
> > On Mon, 1 Dec 2014 15:48:39 +0200
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > On Mon, Dec 01, 2014 at 01:37:40PM +0100, Cornelia Huck wrote:
> > > > On Sun, 30 Nov 2014 17:12:13 +0200
> > > > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > 
> > > > > len is always initialized since function is called with size > 0.
> > > > > 
> > > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > > ---
> > > > >  drivers/vhost/net.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > > > index 984242e..54ffbb0 100644
> > > > > --- a/drivers/vhost/net.c
> > > > > +++ b/drivers/vhost/net.c
> > > > > @@ -501,7 +501,7 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
> > > > >  	int headcount = 0;
> > > > >  	unsigned d;
> > > > >  	int r, nlogs = 0;
> > > > > -	u32 len;
> > > > > +	u32 uninitialized_var(len);
> > > > > 
> > > > >  	while (datalen > 0 && headcount < quota) {
> > > > >  		if (unlikely(seg >= UIO_MAXIOV)) {
> > > > 
> > > > Want to merge this with the patch introducing the variable and add a
> > > > comment there?
> > > 
> > > Not really. Warnings in bisect are fine  I think.
> > 
> > I'm not sure what a separate patch buys us, though, as it should be
> > trivial to merge.
> 
> Easier to document the reason if it's split out.
> 

That's why I suggested a comment ;)

