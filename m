Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab3AaKB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:01:26 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:65073 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3AaKBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:01:22 -0500
Date: Thu, 31 Jan 2013 11:03:30 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        daniel.vetter@ffwll.ch, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: Re: [RESEND PATCH 4/4] GPU/i915: Fix acpi_bus_get_device() check in
 drivers/gpu/drm/i915/intel_opregion.c
Message-ID: <20130131100330.GE5885@phenom.ffwll.local>
Mail-Followup-To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
	airlied@linux.ie, dri-devel@lists.freedesktop.org
References: <1451967.YMyGeCCNtu@vostro.rjw.lan>
 <6099377.PFvsxPeyib@vostro.rjw.lan>
 <5109E11A.5030400@jp.fujitsu.com>
 <5109E2AF.2000107@jp.fujitsu.com>
 <5109E49E.1070005@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5109E49E.1070005@jp.fujitsu.com>
X-Operating-System: Linux phenom 3.8.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:27:26PM +0900, Yasuaki Ishimatsu wrote:
> I forgot to change subject. So I resend a patch.
> 
> ---
> acpi_bus_get_device() returns int not acpi_status.
> 
> The patch change not to apply ACPI_FAILURE() to the return value of
> acpi_bus_get_device().
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

I've tried to apply this to drm-intel-next-queued, but git am didn't
really like your patch - it failed to apply. Can you please rebase to the
drm-intel-next-queued branch from

git://people.freedesktop.org/~danvet/drm-intel

and please resubmit the patch, preferrably formatted with git
format-patch?

Thanks, Daniel

> ---
>  drivers/gpu/drm/i915/intel_opregion.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-pm/drivers/gpu/drm/i915/intel_opregion.c
> ===================================================================
> --- linux-pm.orig/drivers/gpu/drm/i915/intel_opregion.c	2013-01-31 11:39:37.075849905 +0900
> +++ linux-pm/drivers/gpu/drm/i915/intel_opregion.c	2013-01-31 11:52:18.796850274 +0900
> @@ -347,7 +347,7 @@ static void intel_didl_outputs(struct dr
>  	int i = 0;
>  	handle = DEVICE_ACPI_HANDLE(&dev->pdev->dev);
> -	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev)))
> +	if (!handle || acpi_bus_get_device(handle, &acpi_dev))
>  		return;
>  	if (acpi_is_video_device(acpi_dev))
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
