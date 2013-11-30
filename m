Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab3K3NzT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 08:55:19 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:61283 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3K3NzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 08:55:17 -0500
MIME-Version: 1.0
In-Reply-To: <1385800414.7279.3.camel@localhost.localdomain>
References: <E1Vkw2k-00015V-Ao@www17.your-server.de>
	<CAF6AEGsdK4MUm9G8ruX84V5omhej+in7vP5E8skMAoTjRgh7nw@mail.gmail.com>
	<1385800414.7279.3.camel@localhost.localdomain>
Date: Sat, 30 Nov 2013 08:55:16 -0500
Message-ID: <CAF6AEGs9fFQe8_tsDmrWAFH3tvA1a2Bcn62JOCjQ9pD874GNMA@mail.gmail.com>
Subject: Re: [i915] BUG: Bad page state in process Xorg
From: Rob Clark <robdclark@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 3:33 AM, Thomas Meyer <thomas@m3y3r.de> wrote:
> Am Montag, den 25.11.2013, 08:23 -0500 schrieb Rob Clark:
>> oh, hmm.. are you importing buffers from i915?  It looks like this part:
>
> My computer has an i915 graphic card and I use an USB docking station,
> that has an unconnected UDL device inside.
>
>>
>> - if (obj->base.import_attach) {
>> - drm_free_large(obj->pages);
>> - obj->pages = NULL;
>> - return;
>> - }
>>
>> should not have been removed from udl_gem_put_pages()..
>
> Do you want me to test this? Can this please be fixed in the stable
> tree?
> I removed the UDL driver from my config for now, as I don't use it.

It would be nice if you could test that (I can send you a patch if you
prefer)..  I don't actually have any UDL device to confirm.  If this
fixes the problem, send the patch to stable as well should not be a
problem.

BR,
-R


>       *
> best regards
> thomas
>
>>
>> BR,
>> -R
>>
>> On Mon, Nov 25, 2013 at 8:17 AM,  <thomas@m3y3r.de> wrote:
>> > Hi,
>> >
>> > It turns out that this seems to be a bug in udl DRM driver.
>> >
>> > I bisected the problem to this patch:
>> >
>> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/gpu/drm/udl?id=5dc9e1e87229cb786a5bb58ddd0d60fee6eb4641
>> >
>> > With kind regards
>> > Thomas
>> >
>> > Am 22.11.2013 17:18 schrieb Daniel Vetter <daniel@ffwll.ch>:
>> >>
>> >> On Fri, Nov 22, 2013 at 4:54 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
>> >> >> Am 22.11.2013 um 11:55 schrieb Daniel Vetter <daniel@ffwll.ch>:
>> >> >>
>> >> >> On Fri, Nov 22, 2013 at 11:36 AM, Dave Airlie <airlied@linux.ie> wrote:
>> >> >>>> Hi,
>> >> >>>
>> >> >>> cc'ing mailing list,
>> >> >>>
>> >> >>> Daniel any ideas?
>> >> >>
>> >> >> Nope, not really :( And no ideas how to triage this further - if it
>> >> >> takes 9 days to hit it eventually we'll have a real hard time. Or does
>> >> >> this happen even after just a short X run?
>> >> >
>> >> > Seems to happen every time while stopping the x server. Also after a short run time.
>> >> >
>> >> > The current fedora 3.11 kernel doesn't show this bug. I'm using fedora 19, with a self compiled kernel.
>> >> >
>> >> > I did turn on config-debug-pagealloc but this didn't show any wrongness.
>> >>
>> >> In that case I think the bisect is the fastest way to insight - atm
>> >> I'm really at loss what could be wrong here.
>> >> -Daniel
>> >> --
>> >> Daniel Vetter
>> >> Software Engineer, Intel Corporation
>> >> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
>
>
>
