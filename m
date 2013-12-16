Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3LPOZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:25:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab3LPOZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 09:25:29 -0500
Date: Mon, 16 Dec 2013 16:29:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] drivers: virtio: Mark function virtballoon_migratepage()
 as static in virtio_balloon.c
Message-ID: <20131216142911.GA21241@redhat.com>
References: <20131216112408.GA4896@rashika>
 <20131216142338.GA24172@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131216142338.GA24172@leaf>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 06:23:38AM -0800, Josh Triplett wrote:
> On Mon, Dec 16, 2013 at 04:54:08PM +0530, Rashika Kheria wrote:
> > Mark the function virtballoon_migratepage() as static in
> > virtio_balloon.c because it is not used outside this file.
> > 
> > This eliminates the following warning in virtio_balloon.c:
> > drivers/virtio/virtio_balloon.c:372:5: warning: no previous prototype for ‘virtballoon_migratepage’ [-Wmissing-prototypes]
> > 
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> >  drivers/virtio/virtio_balloon.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index c444654..8c5943d 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -369,7 +369,7 @@ static const struct address_space_operations virtio_balloon_aops;
> >   * This function preforms the balloon page migration task.
> >   * Called through balloon_mapping->a_ops->migratepage
> >   */
> > -int virtballoon_migratepage(struct address_space *mapping,
> > +static int virtballoon_migratepage(struct address_space *mapping,
> >  		struct page *newpage, struct page *page, enum migrate_mode mode)
> >  {
> >  	struct balloon_dev_info *vb_dev_info = balloon_page_device(page);
> > -- 
> > 1.7.9.5
> > 
