Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbaGWIqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:46:39 -0400
Received: from pegasos-out.vodafone.de ([80.84.1.38]:33747 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbaGWIqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:46:37 -0400
X-Spam-Flag: NO
X-Spam-Score: 0.2
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=pass
	header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de EE8E56AA8D9
X-DKIM: OpenDKIM Filter v2.0.2 smtp-04.vodafone.de F3E21E5AFD
Message-ID: <53CF765E.7020802@vodafone.de>
Date: Wed, 23 Jul 2014 10:46:22 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser>	<53CE2421.5040906@amd.com>	<20140722114607.GL15237@phenom.ffwll.local>	<20140722115737.GN15237@phenom.ffwll.local>	<53CE56ED.4040109@vodafone.de>	<20140722132652.GO15237@phenom.ffwll.local>	<53CE6AFA.1060807@vodafone.de>	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>	<53CE84AA.9030703@amd.com>	<CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>	<53CE8A57.2000803@vodafone.de>	<53CF58FB.8070609@canonical.com>	<53CF5B9F.1050800@amd.com>	<53CF5EFE.6070307@canonical.com>	<53CF63C2.7070407@vodafone.de>	<CAKMK7uGJj+UwcnnzA+fj_=uWPN3i0sneWkoD+wfPJ_8Q6Y-DQg@mail.gmail.com>	<53CF6622.6060803@amd.com>	<53CF699D.9070902@canonical.com>	<53CF6B18.5070107@vodafone.de>	<CAKMK7uGd65HR11thcv8KjDw-RnTa7W-QGOzFGFd+oO_hp8wyHA@mail.gmail.com>	<53CF7035.2060808@amd.com>	<53CF7191.2090008@canonical.com> <CAKMK7uGLqzePAREsWhX0D1oN4FdqKwPgAL6x8sULpJSqYH5LwA@mail.gmail.com>
In-Reply-To: <CAKMK7uGLqzePAREsWhX0D1oN4FdqKwPgAL6x8sULpJSqYH5LwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.07.2014 10:42, schrieb Daniel Vetter:
> On Wed, Jul 23, 2014 at 10:25 AM, Maarten Lankhorst
> <maarten.lankhorst@canonical.com> wrote:
>> In this case if the sync was to i915 the i915 lockup procedure would take care of itself. It wouldn't fix radeon, but it would at least unblock your intel card again. I haven't specifically added a special case to attempt to unblock external fences, but I've considered it. :-)
> Actually the i915 reset stuff relies crucially on being able to kick
> all waiters holding driver locks. Since the current fence code only
> exposes an opaque wait function without exposing the underlying wait
> queue we won't be able to sleep on both the fence queue and the reset
> queue. So would pose a problem if we add fence_wait calls to our
> driver.

And apart from that I really think that I misunderstood Maarten. But his 
explanation sounds like i915 would do a reset because Radeon is locked 
up, right?

Well if that's really the case then I would question the interface even 
more, cause that is really nonsense.

Christian.

> -Daniel

