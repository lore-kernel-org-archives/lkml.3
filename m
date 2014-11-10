Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaKJLeC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:34:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51019 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaKJLeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:34:00 -0500
Message-ID: <5460A2A6.1020904@canonical.com>
Date: Mon, 10 Nov 2014 12:33:58 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jani Nikula <jani.nikula@linux.intel.com>, Rob Clark <robdclark@gmail.com>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/irq: BUG_ON() -> WARN_ON()
References: <1415459779-30961-1-git-send-email-robdclark@gmail.com> <87sihrz5dm.fsf@intel.com>
In-Reply-To: <87sihrz5dm.fsf@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 10-11-14 om 12:01 schreef Jani Nikula:
> On Sat, 08 Nov 2014, Rob Clark <robdclark@gmail.com> wrote:
>> Let's make things a bit easier to debug when things go bad (potentially
>> under console_lock).
>>
>> Signed-off-by: Rob Clark <robdclark@gmail.com>
>> ---
>>  drivers/gpu/drm/drm_irq.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
>> index 5ef03c2..c4edea9 100644
>> --- a/drivers/gpu/drm/drm_irq.c
>> +++ b/drivers/gpu/drm/drm_irq.c
>> @@ -1029,7 +1029,8 @@ void drm_vblank_put(struct drm_device *dev, int crtc)
>>  {
>>  	struct drm_vblank_crtc *vblank = &dev->vblank[crtc];
>>  
>> -	BUG_ON(atomic_read(&vblank->refcount) == 0);
>> +	if (WARN_ON(atomic_read(&vblank->refcount) == 0))
>> +		return;
> While I approve of the change, I'd like to promote the use of WARN with
> a message instead of WARN_ON. See [1]. In fact it lead to us redefining
> WARN_ON in i915 [2].
I love the redefinition of WARN, but I think this should not be overridden locally, instead it should be a kernel debug option.

~Maarten

