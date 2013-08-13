Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143Ab3HMUQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:16:17 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:53280 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759147Ab3HMUQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:16:16 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130813201042.GA6390@cantiga.alporthouse.com>
References: <CA+icZUXdS3EuXyGZiS1--rMu6H0ospzCiK_CXgPv8mOk0sMt+Q@mail.gmail.com>
	<20130813163439.GA8805@cantiga.alporthouse.com>
	<CA+icZUX8HZD3z-uwTMWX9CoLdYYqyPVuhH-vWGhJuoonvMQTbQ@mail.gmail.com>
	<CA+icZUU1tbHGVPgjXNvsq-F44O6umbhp_bFcoLE35HZ0zTqo2g@mail.gmail.com>
	<20130813171324.GB8805@cantiga.alporthouse.com>
	<CA+icZUWFqpObp_6KzJExPs2pkJOofaKw6CKv8J0=VTfyVy_Uew@mail.gmail.com>
	<20130813180129.GC8805@cantiga.alporthouse.com>
	<CA+icZUWcF6bdoD1pSbbtBTAYNMC9237Eas7SemS6kPpnY=c2Sw@mail.gmail.com>
	<20130813185322.GA5982@cantiga.alporthouse.com>
	<CA+icZUXwSRPoZ8bQ6xaoNz27fQKPtg3HiZRENQ5UEpHE_kmEag@mail.gmail.com>
	<20130813201042.GA6390@cantiga.alporthouse.com>
Date: Tue, 13 Aug 2013 22:16:10 +0200
Message-ID: <CA+icZUXZveDD2s4++CZtUUx1U5_rpAXGeAw-rBnSfPHNXisR6w@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 13 [ screen corruption in graphical mode ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 10:10 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, Aug 13, 2013 at 09:05:41PM +0200, Sedat Dilek wrote:
>> On Tue, Aug 13, 2013 at 8:53 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> > On Tue, Aug 13, 2013 at 08:40:37PM +0200, Sedat Dilek wrote:
>> >> On Tue, Aug 13, 2013 at 8:01 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> >> > On Tue, Aug 13, 2013 at 07:53:25PM +0200, Sedat Dilek wrote:
>> >> >> Files attached.
>> >> >
>> >> > Can you also please attach a full dmesg so I can check for anything
>> >> > unusual?
>> >> >
>> >
>> > Nothing scarred me on a couple of read throughs.
>> >
>> > What happens if you try:
>> >
>> > diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
>> > index 112c5e1..9828d9b 100644
>> > --- a/drivers/gpu/drm/i915/i915_gem_stolen.c
>> > +++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
>> > @@ -284,7 +284,7 @@ i915_gem_object_create_stolen(struct drm_device *dev, u32 size)
>> >                 return NULL;
>> >
>> >         ret = drm_mm_insert_node(&dev_priv->mm.stolen, stolen, size,
>> > -                                4096, DRM_MM_SEARCH_DEFAULT);
>> > +                                1024*1024, DRM_MM_SEARCH_DEFAULT);
>> >         if (ret) {
>> >                 kfree(stolen);
>> >                 return NULL;
>> >
>> > --
>>
>> Now, 2/3 till 3/4 of my LightDM greeter screen is a black bar (seen
>> from the top).
>> On the bottom I can read "Ubuntu 12.04 LTS" with the known background.
>> So-to-say 3/4 "blind".
>
> That implies that the scanout is always reading from the base of stolen.
> Can you grab intel_reg_dumper so that I can check what values the
> transcoder is set to?
>
> At the moment, I am guessing that the display never sees the updated
> surface offset and so persists with the value programmed by the BIOS -
> which will be 0 and set to the base of stolen memory in the GTT. A
> drm.debug=6 dmesg would help here as well.
>
> If you forced a mode change, I think that too would restore the output.

With which kernel? Vanilla next-20130813? With any of your patches?

- Sedat -
