Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3GHANW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 20:13:22 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:46768 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3GHANQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 20:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <1372679333-8473-1-git-send-email-benjamin.guthro@citrix.com>
References: <1372679333-8473-1-git-send-email-benjamin.guthro@citrix.com>
Date: Sun, 7 Jul 2013 20:13:15 -0400
X-Google-Sender-Auth: f4aE39w1VpUYLH-8GaBiRo-nSDI
Message-ID: <CAOvdn6XcEwFa2CRGqUhsaTeTMKHsQeFHJ-KmyCTBZRLbAoimmQ@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH v6 0/5] Xen/ACPI: support sleep state entering
 on hardware reduced systems
From: Ben Guthro <benjamin.guthro@citrix.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>, Bob Moore <robert.moore@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, xen-devel@lists.xen.org,
        Shane Wang <shane.wang@intel.com>, tboot-devel@lists.sourceforge.net,
        Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Gang Wei <gang.wei@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 7:48 AM, Ben Guthro <benjamin.guthro@citrix.com> wrote:
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
> v6: Rebased to linux-pm linux-next branch
>     Added warning in tboot early return code
>     Added Reviewed-by lines
>
> Ben Guthro (5):
>   acpi: Remove need to include linux/acpi.h in common acpica code
>   acpi: Call acpi_os_prepare_sleep hook in reduced hardware sleep path
>   acpi/xen/tboot: Adjust linux acpi OS functions to new extended
>     parameter
>   x86/tboot: Fail extended mode reduced hardware sleep
>   xen/acpi: notify xen when reduced hardware sleep is available

Rafael, Bob -

Is this version of the series something that you may consider taking?
If not - is there something specific you would like to see addressed?

Thanks for your time.


Ben

>
>  arch/x86/kernel/tboot.c          |    9 ++++++++-
>  drivers/acpi/acpica/hwesleep.c   |    7 +++++++
>  drivers/acpi/acpica/hwsleep.c    |    3 +--
>  drivers/acpi/osl.c               |   16 ++++++++--------
>  drivers/xen/acpi.c               |   26 +++++++++++++-------------
>  include/acpi/acpiosxf.h          |    6 ++++++
>  include/linux/acpi.h             |    9 +++------
>  include/xen/acpi.h               |    4 ++--
>  include/xen/interface/platform.h |    7 ++++---
>  9 files changed, 52 insertions(+), 35 deletions(-)
>
> --
> 1.7.9.5
>
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
