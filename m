Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3BAAvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 19:51:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52676 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3BAAvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 19:51:17 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <510B1168.2080401@jp.fujitsu.com>
Date: Fri, 1 Feb 2013 09:50:48 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: <daniel@ffwll.ch>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        <dri-devel@lists.freedesktop.org>
Subject: [UPDATE][PATCH 4/4] GPU/i915: Fix acpi_bus_get_device() check in
 drivers/gpu/drm/i915/intel_opregion.c
References: <1451967.YMyGeCCNtu@vostro.rjw.lan> <6099377.PFvsxPeyib@vostro.rjw.lan> <5109E11A.5030400@jp.fujitsu.com> <5109E2AF.2000107@jp.fujitsu.com> <5109E49E.1070005@jp.fujitsu.com> <20130131100330.GE5885@phenom.ffwll.local>
In-Reply-To: <20130131100330.GE5885@phenom.ffwll.local>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/01/31 19:03, Daniel Vetter wrote:
> On Thu, Jan 31, 2013 at 12:27:26PM +0900, Yasuaki Ishimatsu wrote:
>> I forgot to change subject. So I resend a patch.
>>
>> ---
>> acpi_bus_get_device() returns int not acpi_status.
>>
>> The patch change not to apply ACPI_FAILURE() to the return value of
>> acpi_bus_get_device().
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>
> I've tried to apply this to drm-intel-next-queued, but git am didn't
> really like your patch - it failed to apply. Can you please rebase to the
> drm-intel-next-queued branch from
>
> git://people.freedesktop.org/~danvet/drm-intel
>
> and please resubmit the patch, preferrably formatted with git
> format-patch?

My mailer added a space in the patch. I updated the patch.
How abot it?

---
acpi_bus_get_device() returns int not acpi_status.

The patch change not to apply ACPI_FAILURE() to the return value of
acpi_bus_get_device().

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
  drivers/gpu/drm/i915/intel_opregion.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 7741c22..4d33874 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -347,7 +347,7 @@ static void intel_didl_outputs(struct drm_device *dev)
  	int i = 0;
  
  	handle = DEVICE_ACPI_HANDLE(&dev->pdev->dev);
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev)))
+	if (!handle || acpi_bus_get_device(handle, &acpi_dev))
  		return;
  
  	if (acpi_is_video_device(acpi_dev))

