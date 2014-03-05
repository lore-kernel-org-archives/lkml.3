Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaCEG1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:27:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:8091 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaCEG07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:26:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,591,1389772800"; 
   d="scan'208";a="486273859"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Thomas Renninger <trenn@suse.de>
CC: "Moore, Robert" <robert.moore@intel.com>,
        "Box, David E" <david.e.box@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "ck@conrad-kostecki.de" <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "devel@acpica.org" <devel@acpica.org>
Subject: RE: [PATCH 2/4] ACPICA: Introduce new acpi_os_physical_table_add OS
 callback
Thread-Topic: [PATCH 2/4] ACPICA: Introduce new acpi_os_physical_table_add
 OS callback
Thread-Index: AQHPNn7ETOONm9s0vUeg3rV5HSj6rprOyM0AgAFK6gCAADpLAIABu57Q
Date: Wed, 5 Mar 2014 06:26:54 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024BDA9C@SHSMSX101.ccr.corp.intel.com>
References: <1393608241-31037-1-git-send-email-trenn@suse.de>
 <2330411.KHkNc5Vvtq@skinner>
 <1AE640813FDE7649BE1B193DEA596E88024BD46F@SHSMSX101.ccr.corp.intel.com>
 <1393960620.uGzzRHqAbc@skinner>
In-Reply-To: <1393960620.uGzzRHqAbc@skinner>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas

> From: Thomas Renninger [mailto:trenn@suse.de]
> Sent: Tuesday, March 04, 2014 7:55 PM
> 
> On Tuesday, March 04, 2014 12:31:57 AM Zheng, Lv wrote:
> > Hi,  Thomas
> >
> > > From: Thomas Renninger [mailto:trenn@suse.de]
> > > Sent: Monday, March 03, 2014 8:42 PM
> > >
> > > Hi Lv,
> > >
> > > On Monday, March 03, 2014 01:20:31 AM Zheng, Lv wrote:
> > > > Hi, Thomas
> > > >
> > > > I have a patch series that can cleanup the ACPICA table manager, and
> > > > change
> > >
> > > > the acpi_load_table into the following style:
> > > Ok. I suggest that:
> > > 1) If Thomas (Gleixner) or whoever wants to try out or needs it urgently,
> > > he>
> > >    can (must) use a recent kernel with my patches applied.
> > >
> > > 2) You continue to get your changes into ACPICA.
> > >
> > >    Eventually or best would be if you add whatever is needed to
> > >    allow adding of tables as well (which will be there automatically if
> > >    I understood the description of your changes correctly).
> > >
> > > 3) Either you give it a try yourself or give me short description for
> > >
> > >    what I have to look out for and I can re-post the Linux patches
> > >    based on your ACPICA changes, once they show up in the Linux kernel.
> > >    Best give me a ping as soon as I should look at it.
> >
> > That sounds good.
> >
> > Or it can be more efficient for productions:
> > Linux can merge your patches and ACPICA just stop to take them.
> You mean add my stuff to drivers/acpi/acpica in Linux kernel without
> pushing them into the ACPICA repository?
> 
> I cannot remember that this ever happened (beside small important fixes)
> and I doubt Rafael is willing to do that.
> If it would be super critical, but I cannot see that it is.

OK.

> > This will leave us divergences.
> Yes, that would be bad.

Yes.

> > After the table manager cleanups are tested and shipped in the ACPICA repo,
> > the new facilities will automatically be rolled into Linux branches.
> I'd suggest to just wait for that.
> Best already try to integrate the ACPI table override/add part as you think
> it should work without additional changes in drivers/acpi/acpica.
> 
> If this happened and things are submitted to get integrated into the Linux
> kernel, please add me to CC or point me to the patchset.

Fortunately, there is a kernel bugzilla entry requires this series.
I've posted it on the kernel bugzilla.
Here is the patchset:
https://bugzilla.kernel.org/show_bug.cgi?id=69711
You need to apply 9 patches:
attachment 128061 - attachment 128141
The last patch has introduced an early boot API:
acpi_install_table.
This can be used to enhance this series.

> > Then I
> > can help to reduce the divergences using the new ACPICA facilities. At that
> > time I may ask whoever that can test to offer help to review the cleanup
> > patch.
> 
> I can then give your new patcheset some testing and try to get the Linux
> (drivers/acpi/osl.c) parts (re-)implemented based on your stuff.
> There might still be the one or other minor fix needed that has to go
> into acpica as well, but that should not be that hard to manage and
> might end up in acpica and Linux kernel in parallel without much
> extra overhead.

If you found any issues in using this series, let me know.

Thanks and best regards
-Lv

> 
>      Thomas
