Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab3G0NzH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 09:55:07 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43376 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab3G0NzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 09:55:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ben Guthro <benjamin.guthro@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, xen-devel@lists.xen.org,
        Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Gang Wei <gang.wei@intel.com>, Shane Wang <shane.wang@intel.com>,
        Bob Moore <robert.moore@intel.com>, tboot-devel@lists.sourceforge.net
Subject: Re: [PATCH v5 0/5] Xen/ACPI: support sleep state entering on hardware reduced systems
Date: Sat, 27 Jul 2013 16:05:08 +0200
Message-ID: <3763656.ERXJ8VWMlL@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1372427184-6197-1-git-send-email-benjamin.guthro@citrix.com>
References: <1372427184-6197-1-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 28, 2013 09:46:19 AM Ben Guthro wrote:
> In version 3.4 acpi_os_prepare_sleep() got introduced in parallel with
> reduced hardware sleep support, and the two changes didn't get
> synchronized: The new code doesn't call the hook function (if so
> requested). Fix this, requiring a boolean parameter to be added to the
> hook function to distinguish "extended" from "legacy" sleep.
> 
> This requires adjusting TXT, but the adjustments only go as far as
> failing the extended mode call (since, looking at the TXT interface,
> there doesn't even appear to be precautions to deal with that
> alternative interface).
> 
> The hypervisor change underlying this is commit 62d1a69 ("ACPI: support
> v5 (reduced HW) sleep interface") on the master branch of
> git://xenbits.xen.org/xen.git.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
> Cc: Richard L Maliszewski <richard.l.maliszewski@intel.com>
> Cc: Gang Wei <gang.wei@intel.com>
> Cc: Shane Wang <shane.wang@intel.com>
> Cc: Bob Moore <robert.moore@intel.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Cc: tboot-devel@lists.sourceforge.net 
> 
> v2: Extend description to include reference to hypervisor side change
> v3: Split into multiple patches, separating subsystems
>     Remove bool parameters, in favor of u8
> v4: Remove linux/acpi.h dependencies
>     Further patch split to break out acpica from OSL
>     More bool vs u8 fixes
> v5: Fix build of consumers of acpi_os_prepare_sleep() interface change,
>     so intermediate builds of partial patch series will not fail.
> 
> Ben Guthro (5):
>   acpi: Remove need to include linux/acpi.h in common acpica code
>   acpi: Call acpi_os_prepare_sleep hook in reduced hardware sleep path
>   acpi: Adjust linux acpi OS functions to new extended parameter
>   x86/tboot: Fail extended mode reduced hardware sleep
>   xen/acpi: notify xen when reduced hardware sleep is available

I've just replied to [0/5] from the previous series, here:

http://marc.info/?l=linux-acpi&m=137493312722239&w=2

Thanks,
Rafael

