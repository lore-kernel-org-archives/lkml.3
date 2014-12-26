Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaLZXvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 18:51:55 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58910 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaLZXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 18:51:54 -0500
Date: Fri, 26 Dec 2014 15:51:51 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nouveau: fix ambiguous backlight controls
Message-ID: <20141226235151.GA18697@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Ilia Mirkin <imirkin@alum.mit.edu>, David Airlie <airlied@linux.ie>,
	Ben Skeggs <bskeggs@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1419629187-13916-1-git-send-email-jmmahler@gmail.com>
 <CAKb7Uvi2jXTeD9+pUg6YiQrwK1HaVt2aoC-to1Xw1htvmJao-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKb7Uvi2jXTeD9+pUg6YiQrwK1HaVt2aoC-to1Xw1htvmJao-w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilia,

On Fri, Dec 26, 2014 at 04:39:08PM -0500, Ilia Mirkin wrote:
> On Fri, Dec 26, 2014 at 4:26 PM, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> > If a display supports backlight control using the nouveau driver, and
> > also supports standard ACPI backlight control, there will be two sets of
> > controls.
> >
> > /sys/class/backlight/acpi_video0
> > /sys/class/backlight/nv_backlight
> >
> > This creates ambiguity because these controls can be out of sync with
> > each other.  One could be at 100% while the other is at 0% and the
> > actual display brightness depends on which one was used last.  This also
> > creates anomalies in Powertop which will show two values for brightness
> > with potentially different values.
> >
> > Fix this ambiguity by having the nouveau driver only enable its
> > backlight controls if the standard ACPI controls are not present.
> >
> > Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
> > ---
> >  drivers/gpu/drm/nouveau/nouveau_backlight.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
> > index e566c5b..3a52bd4 100644
> > --- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
> > +++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
> > @@ -221,6 +221,11 @@ nouveau_backlight_init(struct drm_device *dev)
> >         struct nvif_device *device = &drm->device;
> >         struct drm_connector *connector;
> >
> > +       if (acpi_video_backlight_support()) {
> 
> None of the other drivers have this. Is nouveau somehow different
> than, say, radeon in this respect?
> 
> Unfortunately the backlight situation is pretty fubar'd... sometimes
> the acpi controls don't work, sometimes the card controls don't work,
> sometimes they both work but in different ways (and then everyone's
> favourite -- neither works, and there's some third platform thing).
> I'm pretty sure this code existed before, but got removed. See commit
> bee564430feec1175ee64bcfd4913cacc519f817 and the previous commit
> 5bead799d3f8 before that. The ping-pong is probably not the right way
> to go.
> 

I was not aware of that change. But you are right, it took out what I
was trying to put back in.

Thanks for the helpful information.  I will have to rethink this fix.

[...]

-- 
- Jeremiah Mahler
