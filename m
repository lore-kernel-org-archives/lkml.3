Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab3G3NGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:06:39 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47374 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab3G3NGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:06:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ben Guthro <benjamin.guthro@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, xen-devel@lists.xen.org,
        Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Gang Wei <gang.wei@intel.com>, Shane Wang <shane.wang@intel.com>,
        Bob Moore <robert.moore@intel.com>, tboot-devel@lists.sourceforge.net
Subject: Re: [PATCH v8 0/3] Xen/ACPI: support sleep state entering on hardware reduced systems
Date: Tue, 30 Jul 2013 15:16:44 +0200
Message-ID: <1712849.Df3Hfvh1Az@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1375187094-19357-1-git-send-email-benjamin.guthro@citrix.com>
References: <1375187094-19357-1-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 30, 2013 08:24:51 AM Ben Guthro wrote:
> In version 3.4 acpi_os_prepare_sleep() got introduced in parallel with
> reduced hardware sleep support, and the two changes didn't get
> synchronized: The new code doesn't call the hook function (if so
> requested). Fix this, requiring a new callback to be added to acpica
> to be called back during this reduced hardware sleep.
> 
> This requires adjusting TXT, but the adjustments only go as far as
> failing the extended mode call (since, looking at the TXT interface,
> there doesn't even appear to be precautions to deal with that
> alternative interface).
> 
> The xen hypervisor change underlying this is commit 62d1a69 ("ACPI: support
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
> v6: Rebased to linux-pm linux-next branch
>     Added warning in tboot early return code
>     Added Reviewed-by lines
> v7: Add separate acpi_os_prepare_extended_sleep() interface
>     Remove OSL acpica changes introduced in v4
> v8: Return meaningful error code in tboot error path
> 
> Ben Guthro (3):
>   x86/acpi: Introduce acpi_os_prepare_extended_sleep callback for
>     extended sleep path
>   x86/tboot: Fail extended mode reduced hardware sleep
>   xen/acpi: notify xen when reduced hardware sleep is available
> 
>  arch/x86/kernel/tboot.c          |   12 +++++++++++
>  drivers/acpi/acpica/hwesleep.c   |    9 +++++++++
>  drivers/acpi/osl.c               |   24 ++++++++++++++++++++++
>  drivers/xen/acpi.c               |   41 ++++++++++++++++++++++++++------------
>  include/linux/acpi.h             |    7 +++++++
>  include/xen/acpi.h               |    8 ++++++--
>  include/xen/interface/platform.h |    7 ++++---
>  7 files changed, 90 insertions(+), 18 deletions(-)

Please modify [2/3] as requested in the other message, [1/3] and [3/3] are OK
and don't need to be resent.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
