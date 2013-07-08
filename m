Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3GHNBC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:01:02 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34402 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab3GHNA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:00:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ben Guthro <benjamin.guthro@citrix.com>
Cc: Bob Moore <robert.moore@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, xen-devel@lists.xen.org,
        Shane Wang <shane.wang@intel.com>, tboot-devel@lists.sourceforge.net,
        Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Gang Wei <gang.wei@intel.com>
Subject: Re: [Xen-devel] [PATCH v6 0/5] Xen/ACPI: support sleep state entering on hardware reduced systems
Date: Mon, 08 Jul 2013 15:10:40 +0200
Message-ID: <2101936.oHXzxvYCX4@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAOvdn6XcEwFa2CRGqUhsaTeTMKHsQeFHJ-KmyCTBZRLbAoimmQ@mail.gmail.com>
References: <1372679333-8473-1-git-send-email-benjamin.guthro@citrix.com> <CAOvdn6XcEwFa2CRGqUhsaTeTMKHsQeFHJ-KmyCTBZRLbAoimmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 07, 2013 08:13:15 PM Ben Guthro wrote:
> On Mon, Jul 1, 2013 at 7:48 AM, Ben Guthro <benjamin.guthro@citrix.com> wrote:
> > In version 3.4 acpi_os_prepare_sleep() got introduced in parallel with
> > reduced hardware sleep support, and the two changes didn't get
> > synchronized: The new code doesn't call the hook function (if so
> > requested). Fix this, requiring a boolean parameter to be added to the
> > hook function to distinguish "extended" from "legacy" sleep.
> >
> > This requires adjusting TXT, but the adjustments only go as far as
> > failing the extended mode call (since, looking at the TXT interface,
> > there doesn't even appear to be precautions to deal with that
> > alternative interface).
> >
> > The hypervisor change underlying this is commit 62d1a69 ("ACPI: support
> > v5 (reduced HW) sleep interface") on the master branch of
> > git://xenbits.xen.org/xen.git.
> >
> > Signed-off-by: Jan Beulich <jbeulich@suse.com>
> > Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
> > Cc: Richard L Maliszewski <richard.l.maliszewski@intel.com>
> > Cc: Gang Wei <gang.wei@intel.com>
> > Cc: Shane Wang <shane.wang@intel.com>
> > Cc: Bob Moore <robert.moore@intel.com>
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: linux-acpi@vger.kernel.org
> > Cc: tboot-devel@lists.sourceforge.net
> >
> > v2: Extend description to include reference to hypervisor side change
> > v3: Split into multiple patches, separating subsystems
> >     Remove bool parameters, in favor of u8
> > v4: Remove linux/acpi.h dependencies
> >     Further patch split to break out acpica from OSL
> >     More bool vs u8 fixes
> > v5: Fix build of consumers of acpi_os_prepare_sleep() interface change,
> >     so intermediate builds of partial patch series will not fail.
> > v6: Rebased to linux-pm linux-next branch
> >     Added warning in tboot early return code
> >     Added Reviewed-by lines
> >
> > Ben Guthro (5):
> >   acpi: Remove need to include linux/acpi.h in common acpica code
> >   acpi: Call acpi_os_prepare_sleep hook in reduced hardware sleep path
> >   acpi/xen/tboot: Adjust linux acpi OS functions to new extended
> >     parameter
> >   x86/tboot: Fail extended mode reduced hardware sleep
> >   xen/acpi: notify xen when reduced hardware sleep is available
> 
> Rafael, Bob -
> 
> Is this version of the series something that you may consider taking?
> If not - is there something specific you would like to see addressed?

Well, I'm afraid you need to give us some more time to process that,
sorry.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
