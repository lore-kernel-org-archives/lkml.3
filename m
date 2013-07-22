Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3GVMrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:47:36 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60714 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab3GVMrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:47:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ben Guthro <benjamin.guthro@citrix.com>,
        Bob Moore <robert.moore@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, xen-devel@lists.xen.org,
        Shane Wang <shane.wang@intel.com>, tboot-devel@lists.sourceforge.net,
        Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Gang Wei <gang.wei@intel.com>
Subject: Re: [Xen-devel] [PATCH v6 0/5] Xen/ACPI: support sleep state entering on hardware reduced systems
Date: Mon, 22 Jul 2013 14:57:26 +0200
Message-ID: <3107214.itlfxJnXsN@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAOvdn6Wv1mXD-RDCZ750YQFEFf7GR0QxVARACEg0jNrUEEkBYA@mail.gmail.com>
References: <1372679333-8473-1-git-send-email-benjamin.guthro@citrix.com> <51DAB9B8.7060303@citrix.com> <CAOvdn6Wv1mXD-RDCZ750YQFEFf7GR0QxVARACEg0jNrUEEkBYA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 22, 2013 08:44:08 AM Ben Guthro wrote:
> On Mon, Jul 8, 2013 at 9:08 AM, Ben Guthro <Benjamin.Guthro@citrix.com> wrote:
> >
> >
> > On 07/08/2013 09:10 AM, Rafael J. Wysocki wrote:
> >> On Sunday, July 07, 2013 08:13:15 PM Ben Guthro wrote:
> >>> On Mon, Jul 1, 2013 at 7:48 AM, Ben Guthro <benjamin.guthro@citrix.com> wrote:
> >>>> In version 3.4 acpi_os_prepare_sleep() got introduced in parallel with
> >>>> reduced hardware sleep support, and the two changes didn't get
> >>>> synchronized: The new code doesn't call the hook function (if so
> >>>> requested). Fix this, requiring a boolean parameter to be added to the
> >>>> hook function to distinguish "extended" from "legacy" sleep.
> >>>>
> >>>> This requires adjusting TXT, but the adjustments only go as far as
> >>>> failing the extended mode call (since, looking at the TXT interface,
> >>>> there doesn't even appear to be precautions to deal with that
> >>>> alternative interface).
> >>>>
> >>>> The hypervisor change underlying this is commit 62d1a69 ("ACPI: support
> >>>> v5 (reduced HW) sleep interface") on the master branch of
> >>>> git://xenbits.xen.org/xen.git.
> >>>>
> >>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> >>>> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
> >>>> Cc: Richard L Maliszewski <richard.l.maliszewski@intel.com>
> >>>> Cc: Gang Wei <gang.wei@intel.com>
> >>>> Cc: Shane Wang <shane.wang@intel.com>
> >>>> Cc: Bob Moore <robert.moore@intel.com>
> >>>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> >>>> Cc: linux-acpi@vger.kernel.org
> >>>> Cc: tboot-devel@lists.sourceforge.net
> >>>>
> >>>> v2: Extend description to include reference to hypervisor side change
> >>>> v3: Split into multiple patches, separating subsystems
> >>>>     Remove bool parameters, in favor of u8
> >>>> v4: Remove linux/acpi.h dependencies
> >>>>     Further patch split to break out acpica from OSL
> >>>>     More bool vs u8 fixes
> >>>> v5: Fix build of consumers of acpi_os_prepare_sleep() interface change,
> >>>>     so intermediate builds of partial patch series will not fail.
> >>>> v6: Rebased to linux-pm linux-next branch
> >>>>     Added warning in tboot early return code
> >>>>     Added Reviewed-by lines
> >>>>
> >>>> Ben Guthro (5):
> >>>>   acpi: Remove need to include linux/acpi.h in common acpica code
> >>>>   acpi: Call acpi_os_prepare_sleep hook in reduced hardware sleep path
> >>>>   acpi/xen/tboot: Adjust linux acpi OS functions to new extended
> >>>>     parameter
> >>>>   x86/tboot: Fail extended mode reduced hardware sleep
> >>>>   xen/acpi: notify xen when reduced hardware sleep is available
> >>>
> >>> Rafael, Bob -
> >>>
> >>> Is this version of the series something that you may consider taking?
> >>> If not - is there something specific you would like to see addressed?
> >>
> >> Well, I'm afraid you need to give us some more time to process that,
> >> sorry.
> >
> > My apologies - I know it is a busy time during the merge window. I did
> > not mean to seem impatient.
> >
> > With the volume of things on the mailing list, I merely wanted to try to
> > avoid the series getting buried. If a week is too frequent to re-bump a
> > series, do you have a set of recommendations of how to best interact
> > with your workflow?
> 
> Rafael (et al.)
> 
> I never heard back on this point of how you prefer your workflow to
> proceed - that is, if I haven't heard anything in a couple weeks -
> should I try to re-bump the thread?

I don't think you need to.  I'm waiting for Bob's comments at this point.

Bob, do you have any objections agains the Ben's patches?

Rafael


> Since this was sent around the time of the merge window, I realize
> there were other things to occupy people's time.
> Now that rc2 is out - I'm hoping that the dust has settled a bit, such
> that there may be a cycle, or two to review this series.
> 
> Thanks for your time
> 
> Ben
> 
> >
> > I'm just trying to balance people's time to review such things, with the
> > volume of the list.
> >
> > Thanks for your time.
> >
> > Ben
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
