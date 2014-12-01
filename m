Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaLAMnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:43:01 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:50694 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbaLAMm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:42:59 -0500
Date: Mon, 1 Dec 2014 13:42:47 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 31/46] vhost: virtio 1.0 endian-ness support
Message-ID: <20141201134247.55e68161.cornelia.huck@de.ibm.com>
In-Reply-To: <20141201123701.GB17958@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-32-git-send-email-mst@redhat.com>
	<20141201133353.0bbaa2e1.cornelia.huck@de.ibm.com>
	<20141201123701.GB17958@redhat.com>
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
x-cbid: 14120112-0041-0000-0000-000002510635
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 14:37:01 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Dec 01, 2014 at 01:33:53PM +0100, Cornelia Huck wrote:
> > On Sun, 30 Nov 2014 17:11:49 +0200
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >  drivers/vhost/vhost.c | 93 +++++++++++++++++++++++++++++++--------------------
> > >  1 file changed, 56 insertions(+), 37 deletions(-)
> > > 
> > 
> > > @@ -1113,18 +1120,19 @@ static int get_indirect(struct vhost_virtqueue *vq,
> > >  {
> > >  	struct vring_desc desc;
> > >  	unsigned int i = 0, count, found = 0;
> > > +	u32 len = vhost32_to_cpu(vq, indirect->len);
> > >  	int ret;
> > > 
> > >  	/* Sanity check */
> > > -	if (unlikely(indirect->len % sizeof desc)) {
> > > +	if (unlikely(len % sizeof desc)) {
> > >  		vq_err(vq, "Invalid length in indirect descriptor: "
> > >  		       "len 0x%llx not multiple of 0x%zx\n",
> > > -		       (unsigned long long)indirect->len,
> > > +		       (unsigned long long)vhost32_to_cpu(vq, indirect->len),
> > 
> > Can't you use len here?
> 
> Not if I want error message to be readable.

Huh? Both have the same value.

