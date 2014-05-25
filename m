Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaEYW4I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 18:56:08 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33063 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750764AbaEYW4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 18:56:05 -0400
Date: Sun, 25 May 2014 23:54:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH linux-next] DRM: Armada: update dma_buf_export use
Message-ID: <20140525225435.GZ3693@n2100.arm.linux.org.uk>
References: <1400965544-20092-1-git-send-email-vincent.stehle@laposte.net> <CANq1E4QdGeHeuCu9LvPkbGZX5C+ax4fWVqq4kJ5wMUBx5uWZrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4QdGeHeuCu9LvPkbGZX5C+ax4fWVqq4kJ5wMUBx5uWZrQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 02:08:48PM +0200, David Herrmann wrote:
> Hi
> 
> On Sat, May 24, 2014 at 11:05 PM, Vincent Stehlé
> <vincent.stehle@laposte.net> wrote:
> > The dma_buf_export function was updated in commit 4bcec44ffaf9 'dma-buf: use
> > reservation objects' to take a reservation object parameter; update Armada
> > export method accordingly.
> >
> > This fixes the following compilation error:
> >
> >   drivers/gpu/drm/armada/armada_gem.c: In function ‘armada_gem_prime_export’:
> >   drivers/gpu/drm/armada/armada_gem.c:544:16: error: macro "dma_buf_export" requires 5 arguments, but only 4 given
> >
> > Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> > Cc: Sumit Semwal <sumit.semwal@linaro.org>
> 
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Airlied, can you merge this please?  Thanks.

> Thanks
> David
> 
> > ---
> >
> > Hi,
> >
> > This can be seen with e.g. linux next-20140523 and arm allmodconfig.
> >
> > Best regards,
> >
> > V.
> >
> >  drivers/gpu/drm/armada/armada_gem.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
> > index 887816f..7adb0c3 100644
> > --- a/drivers/gpu/drm/armada/armada_gem.c
> > +++ b/drivers/gpu/drm/armada/armada_gem.c
> > @@ -541,7 +541,7 @@ armada_gem_prime_export(struct drm_device *dev, struct drm_gem_object *obj,
> >         int flags)
> >  {
> >         return dma_buf_export(obj, &armada_gem_prime_dmabuf_ops, obj->size,
> > -                             O_RDWR);
> > +                             O_RDWR, NULL);
> >  }
> >
> >  struct drm_gem_object *
> > --
> > 2.0.0.rc2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
