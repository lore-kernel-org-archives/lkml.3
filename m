Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3BAKBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:01:12 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33836 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab3BAKBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:01:08 -0500
Date: Fri, 1 Feb 2013 11:03:17 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: daniel@ffwll.ch, "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [UPDATE][PATCH 4/4] GPU/i915: Fix acpi_bus_get_device() check in
 drivers/gpu/drm/i915/intel_opregion.c
Message-ID: <20130201100317.GG5885@phenom.ffwll.local>
Mail-Followup-To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
	dri-devel@lists.freedesktop.org
References: <1451967.YMyGeCCNtu@vostro.rjw.lan>
 <6099377.PFvsxPeyib@vostro.rjw.lan>
 <5109E11A.5030400@jp.fujitsu.com>
 <5109E2AF.2000107@jp.fujitsu.com>
 <5109E49E.1070005@jp.fujitsu.com>
 <20130131100330.GE5885@phenom.ffwll.local>
 <510B1168.2080401@jp.fujitsu.com>
 <510B1200.3000509@jp.fujitsu.com>
 <510B16EC.7030903@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510B16EC.7030903@jp.fujitsu.com>
X-Operating-System: Linux phenom 3.8.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 10:14:20AM +0900, Yasuaki Ishimatsu wrote:
> 2013/02/01 9:53, Yasuaki Ishimatsu wrote:
> >2013/02/01 9:50, Yasuaki Ishimatsu wrote:
> >>2013/01/31 19:03, Daniel Vetter wrote:
> >>>On Thu, Jan 31, 2013 at 12:27:26PM +0900, Yasuaki Ishimatsu wrote:
> >>>>I forgot to change subject. So I resend a patch.
> >>>>
> >>>>---
> >>>>acpi_bus_get_device() returns int not acpi_status.
> >>>>
> >>>>The patch change not to apply ACPI_FAILURE() to the return value of
> >>>>acpi_bus_get_device().
> >>>>
> >>>>Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> >>>
> >>>I've tried to apply this to drm-intel-next-queued, but git am didn't
> >>>really like your patch - it failed to apply. Can you please rebase to the
> >>>drm-intel-next-queued branch from
> >>>
> >>>git://people.freedesktop.org/~danvet/drm-intel
> >>>
> >>>and please resubmit the patch, preferrably formatted with git
> >>>format-patch?
> >>
> >>My mailer added a space in the patch. I updated the patch.
> >>How abot it?
> >>
> >>---
> >>acpi_bus_get_device() returns int not acpi_status.
> >>
> >>The patch change not to apply ACPI_FAILURE() to the return value of
> >>acpi_bus_get_device().
> >>
> >>Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> >>---
> >>  drivers/gpu/drm/i915/intel_opregion.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >>diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
> >>index 7741c22..4d33874 100644
> >>--- a/drivers/gpu/drm/i915/intel_opregion.c
> >>+++ b/drivers/gpu/drm/i915/intel_opregion.c
> >>@@ -347,7 +347,7 @@ static void intel_didl_outputs(struct drm_device *dev)
> >>      int i = 0;
> >>
> >>      handle = DEVICE_ACPI_HANDLE(&dev->pdev->dev);
> >>-    if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev)))
> >>+    if (!handle || acpi_bus_get_device(handle, &acpi_dev))
> >>          return;
> >>
> >>      if (acpi_is_video_device(acpi_dev))
> >>
> >
> >Oops. My mailer added a space again...
> >I'll check my mailer again.
> 
> I do not understand why space was added to the patch.
> So I attached the patch. Please check it.

Yeah, worked this time. Queued for -next, thanks for the patch.
-Daniel

> 
> Thanks,
> Yasuaki Ishimatsu
> 
> >
> >Thanks,
> >Yasuaki Ishimatsu
> >
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

> acpi_bus_get_device() returns int not acpi_status.
> 
> The patch change not to apply ACPI_FAILURE() to the return value of
> acpi_bus_get_device().
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
>  drivers/gpu/drm/i915/intel_opregion.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
> index 7741c22..4d33874 100644
> --- a/drivers/gpu/drm/i915/intel_opregion.c
> +++ b/drivers/gpu/drm/i915/intel_opregion.c
> @@ -347,7 +347,7 @@ static void intel_didl_outputs(struct drm_device *dev)
>  	int i = 0;
>  
>  	handle = DEVICE_ACPI_HANDLE(&dev->pdev->dev);
> -	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev)))
> +	if (!handle || acpi_bus_get_device(handle, &acpi_dev))
>  		return;
>  
>  	if (acpi_is_video_device(acpi_dev))
> 


-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
