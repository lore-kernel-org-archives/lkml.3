Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbaGWI0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:26:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47482 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbaGWI0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:26:02 -0400
Message-ID: <53CF7191.2090008@canonical.com>
Date: Wed, 23 Jul 2014 10:25:53 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>
CC: Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser>	<20140709122953.11354.46381.stgit@patser>	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>	<53CE2421.5040906@amd.com>	<20140722114607.GL15237@phenom.ffwll.local>	<20140722115737.GN15237@phenom.ffwll.local>	<53CE56ED.4040109@vodafone.de>	<20140722132652.GO15237@phenom.ffwll.local>	<53CE6AFA.1060807@vodafone.de>	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>	<53CE84AA.9030703@amd.com>	<CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>	<53CE8A57.2000803@vodafone.de>	<53CF58FB.8070609@canonical.com>	<53CF5B9F.1050800@amd.com>	<53CF5EFE.6070307@canonical.com>	<53CF63C2.7070407@vodafone.de>	<CAKMK7uGJj+UwcnnzA+fj_=uWPN3i0sneWkoD+wfPJ_8Q6Y-DQg@mail.gmail.com>	<53CF6622.6060803@amd.com>	<53CF699D.9070902@canonical.com>	<53CF6B18.5070107@vodafone.de> <CAKMK7uGd65HR11thcv8KjDw-RnTa7W-QGOzFGFd+oO_hp8wyHA@mail.gmail.com> <53CF7035.2060808@amd.com>
In-Reply-To: <53CF7035.2060808@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 23-07-14 10:20, Christian König schreef:
> Am 23.07.2014 10:07, schrieb Daniel Vetter:
>> On Wed, Jul 23, 2014 at 9:58 AM, Christian König
>> <deathsimple@vodafone.de> wrote:
>>> Just imagine an application using prime is locking up Radeon and because of
>>> that gets killed by the user. Nothing else in the system would use the
>>> Radeon hardware any more and so radeon gets only called by another driver
>>> waiting patiently for radeon to finish rendering which never happens because
>>> the whole thing is locked up and we don't get a chance to recover.
>> But isn't that possible already without fences? X hangs radeon, user
>> crashes X for unrelated reasons before radeon will notice the hang.
>> Then no one uses radeon any longer and the hang stays undetected.
>
> Yeah, especially with multimedia application. But I don't really care about this problem because the next time an application tries to use the block in question we actually do the reset and everything is fine.
>
> In your example we would do the reset when the next X server starts, before that point nobody would care because nobody uses the hardware.
>
> An additional problem here is that resets are something perfect normal for radeon. For example UVD can "crash" when you feed it with invalid bitstream data, (ok actually it send an interrupt and stops any processing for the driver to investigate). To continue processing you need to go through a rather complicated reset procedure.
In this case if the sync was to i915 the i915 lockup procedure would take care of itself. It wouldn't fix radeon, but it would at least unblock your intel card again. I haven't specifically added a special case to attempt to unblock external fences, but I've considered it. :-)

~Maarten

