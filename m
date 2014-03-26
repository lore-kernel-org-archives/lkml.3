Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaCZEUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 00:20:48 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:54394 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaCZEUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 00:20:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140324221314.GD17218@mithrandir>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
	<1395650554-31925-4-git-send-email-acourbot@nvidia.com>
	<20140324221314.GD17218@mithrandir>
Date: Wed, 26 Mar 2014 14:20:42 +1000
Message-ID: <CACAvsv6USpTOe4H3fhabHbPOmjSV8VeQWakVCkQS6doqPed6fQ@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 03/12] drm/nouveau/bar: only ioremap BAR3 if it exists
From: Ben Skeggs <skeggsb@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 8:13 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Mar 24, 2014 at 05:42:25PM +0900, Alexandre Courbot wrote:
>> Some chips that use system memory exclusively (e.g. GK20A) do not
>> expose 2 BAR regions. For them only BAR1 exists, and it should be used
>> for USERD mapping. Do not map BAR3 if its resource does not exist.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  drivers/gpu/drm/nouveau/core/subdev/bar/base.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/base.c b/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
>> index bdf594116f3f..d713eeb75b13 100644
>> --- a/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
>> +++ b/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
>> @@ -110,6 +110,7 @@ nouveau_bar_create_(struct nouveau_object *parent,
>>  {
>>       struct nouveau_device *device = nv_device(parent);
>>       struct nouveau_bar *bar;
>> +     bool has_bar3 = nv_device_resource_len(device, 3) != 0;
>
> I don't think this variable is really necessary since you only use the
> expression once anyway, but I don't feel very strongly about it, so
> either way:
I'd also prefer it folded in, but it's not a big deal.  A couple of
other upcoming comments will require a re-spin anyway, so we may as
well :)

>
> Reviewed-by: Thierry Reding <treding@nvidia.com>
>
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau
>
