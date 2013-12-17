Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3LQEye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 23:54:34 -0500
Received: from ozlabs.org ([203.10.76.45]:46162 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab3LQEyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 23:54:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] drivers: virtio: Mark function virtballoon_migratepage() as static in virtio_balloon.c
In-Reply-To: <20131216142911.GA21241@redhat.com>
References: <20131216112408.GA4896@rashika> <20131216142338.GA24172@leaf> <20131216142911.GA21241@redhat.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 17 Dec 2013 15:09:22 +1030
Message-ID: <87d2kwm6px.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Mon, Dec 16, 2013 at 06:23:38AM -0800, Josh Triplett wrote:
>> On Mon, Dec 16, 2013 at 04:54:08PM +0530, Rashika Kheria wrote:
>> > Mark the function virtballoon_migratepage() as static in
>> > virtio_balloon.c because it is not used outside this file.
>> > 
>> > This eliminates the following warning in virtio_balloon.c:
>> > drivers/virtio/virtio_balloon.c:372:5: warning: no previous prototype for ‘virtballoon_migratepage’ [-Wmissing-prototypes]
>> > 
>> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>> 
>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Thanks, applied.

Cheers,
Rusty.

>
>> >  drivers/virtio/virtio_balloon.c |    2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> > 
>> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
>> > index c444654..8c5943d 100644
>> > --- a/drivers/virtio/virtio_balloon.c
>> > +++ b/drivers/virtio/virtio_balloon.c
>> > @@ -369,7 +369,7 @@ static const struct address_space_operations virtio_balloon_aops;
>> >   * This function preforms the balloon page migration task.
>> >   * Called through balloon_mapping->a_ops->migratepage
>> >   */
>> > -int virtballoon_migratepage(struct address_space *mapping,
>> > +static int virtballoon_migratepage(struct address_space *mapping,
>> >  		struct page *newpage, struct page *page, enum migrate_mode mode)
>> >  {
>> >  	struct balloon_dev_info *vb_dev_info = balloon_page_device(page);
>> > -- 
>> > 1.7.9.5
>> > 
