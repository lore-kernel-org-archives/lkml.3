Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3ENNhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 09:37:42 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:63046 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab3ENNhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 09:37:40 -0400
MIME-Version: 1.0
In-Reply-To: <CADnq5_O6tZeRVq=gmJfn3JWQGgECSE1JuonpSKgFCYSD8RCqHQ@mail.gmail.com>
References: <cover.1368485053.git.luto@amacapital.net>
	<bf7788cfd4695d05f2b414735744105906650e42.1368485053.git.luto@amacapital.net>
	<CADnq5_O6tZeRVq=gmJfn3JWQGgECSE1JuonpSKgFCYSD8RCqHQ@mail.gmail.com>
Date: Tue, 14 May 2013 09:37:39 -0400
Message-ID: <CAH3drwbSLdjd4Y8x8YfzhM5WK+A-L7mnYeS0kdqu7MwEB5kbCQ@mail.gmail.com>
Subject: Re: [PATCH v3 6/9] radeon: Switch to arch_phys_wc_add and add a
 missing ..._del
From: Jerome Glisse <j.glisse@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 8:58 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Mon, May 13, 2013 at 7:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

I believe it will break something but we could deal with the fallout
once it happens.

>> ---
>>  drivers/gpu/drm/radeon/radeon_object.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
>> index d3aface..15cd34b 100644
>> --- a/drivers/gpu/drm/radeon/radeon_object.c
>> +++ b/drivers/gpu/drm/radeon/radeon_object.c
>> @@ -321,8 +321,8 @@ void radeon_bo_force_delete(struct radeon_device *rdev)
>>  int radeon_bo_init(struct radeon_device *rdev)
>>  {
>>         /* Add an MTRR for the VRAM */
>> -       rdev->mc.vram_mtrr = mtrr_add(rdev->mc.aper_base, rdev->mc.aper_size,
>> -                       MTRR_TYPE_WRCOMB, 1);
>> +       rdev->mc.vram_mtrr = arch_phys_wc_add(rdev->mc.aper_base,
>> +                                             rdev->mc.aper_size);
>>         DRM_INFO("Detected VRAM RAM=%lluM, BAR=%lluM\n",
>>                 rdev->mc.mc_vram_size >> 20,
>>                 (unsigned long long)rdev->mc.aper_size >> 20);
>> @@ -334,6 +334,7 @@ int radeon_bo_init(struct radeon_device *rdev)
>>  void radeon_bo_fini(struct radeon_device *rdev)
>>  {
>>         radeon_ttm_fini(rdev);
>> +       arch_phys_wc_del(rdev->mc.vram_mtrr);
>>  }
>>
>>  void radeon_bo_list_add_object(struct radeon_bo_list *lobj,
>> --
>> 1.8.1.4
>>
