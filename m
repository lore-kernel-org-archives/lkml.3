Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbaISKTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:19:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbaISKTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:19:08 -0400
Message-ID: <1411121943.24750.12.camel@nilsson.home.kraxel.org>
Subject: Re: [PATCH 1/2] cirrus: add missing drm_connector_register call
From: Gerd Hoffmann <kraxel@redhat.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Fri, 19 Sep 2014 12:19:03 +0200
In-Reply-To: <CANq1E4RUnO0VTSP++ONddAV1tiLOvQwGwxwzNZ3FvYnaObQdaA@mail.gmail.com>
References: <1411114297-13910-1-git-send-email-kraxel@redhat.com>
	 <1411114297-13910-2-git-send-email-kraxel@redhat.com>
	 <CANq1E4RUnO0VTSP++ONddAV1tiLOvQwGwxwzNZ3FvYnaObQdaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 2014-09-19 at 10:37 +0200, David Herrmann wrote:
> Hi
> 
> On Fri, Sep 19, 2014 at 10:11 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
> > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> > ---
> >  drivers/gpu/drm/cirrus/cirrus_mode.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/gpu/drm/cirrus/cirrus_mode.c b/drivers/gpu/drm/cirrus/cirrus_mode.c
> > index e1c5c32..c7c5a9d 100644
> > --- a/drivers/gpu/drm/cirrus/cirrus_mode.c
> > +++ b/drivers/gpu/drm/cirrus/cirrus_mode.c
> > @@ -555,6 +555,7 @@ static struct drm_connector *cirrus_vga_init(struct drm_device *dev)
> >
> >         drm_connector_helper_add(connector, &cirrus_vga_connector_helper_funcs);
> >
> > +       drm_connector_register(connector);
> 
> Error checking?

Hmm, I see plenty of calls like this in the kernel.

Also: What should happen on error?  The driver itself and cirrusdrmfb
works just fine without that, so I don't feel like failing driver
initialization because of that, as that would break the console ...

> And should probably include "Cc: <stable@vger.kernel.org> # v3.15+".

Commit 2ee39452fa2fff1e8edb954ccb7e0daee9646557 (v3.17 merge window)
exposes the bug, so stable kernels are working just fine.

cheers,
  Gerd


