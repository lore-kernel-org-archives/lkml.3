Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbbAMFm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:42:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:40785 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbbAMFmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:42:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,747,1413270000"; 
   d="scan'208";a="636434707"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Zheng, Lv" <lv.zheng@intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: RE: [Devel] [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
Thread-Topic: [Devel] [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
Thread-Index: AQHQKNIe6YwEecfkn02ZwABJi6oKXZyyPR8AgAC7LACACmgy4IAANEyw
Date: Tue, 13 Jan 2015 05:42:16 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026ADAD3@SHSMSX101.ccr.corp.intel.com>
References: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
 <1418381488-25123-3-git-send-email-linux@rasmusvillemoes.dk>
 <1AE640813FDE7649BE1B193DEA596E88026AACD9@SHSMSX101.ccr.corp.intel.com>
 <87oaqdy13n.fsf@rasmusvillemoes.dk>
 <1AE640813FDE7649BE1B193DEA596E88026AB06A@SHSMSX101.ccr.corp.intel.com>
 <20150106193610.GA7141@pathfinder>
 <1AE640813FDE7649BE1B193DEA596E88026AC9E4@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88026AC9E4@SHSMSX101.ccr.corp.intel.com>
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

Hi, Rasmus

Just for your information.

There is also a known bug related to the application header printing.
The fix is:
https://github.com/zetalog/acpica/commit/79e75432
But this bug can only be seen for EFI ports of ACPICA utilities, it won't be detected in the kernel source tree.
Hope this is not the motivation that has caused you to try to remove the __DATE__ usages.

Thanks and best regards
-Lv

> From: Devel [mailto:devel-bounces@acpica.org] On Behalf Of Zheng, Lv
> Sent: Tuesday, January 13, 2015 10:33 AM
> 
> Hi,
> 
> I've added this patch into the 201501 ACPICA materials for review:
> https://github.com/acpica/acpica/pull/61
> If it is merged, it will appear in Linux kernel after 201501 ACPICA release.
> Thanks for reporting.
> 
> Best regards
> -Lv
> 
> > From: David E. Box [mailto:david.e.box@linux.intel.com]
> > Sent: Wednesday, January 07, 2015 3:36 AM
> >
> > On Tue, Jan 06, 2015 at 12:30:05AM +0000, Zheng, Lv wrote:
> > > Hi,
> > >
> > > > From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
> > > > Sent: Monday, January 05, 2015 6:27 PM
> > > >
> > > > On Mon, Jan 05 2015, "Zheng, Lv" <lv.zheng@intel.com> wrote:
> > > >
> > > > > Hi,
> > > > >
> > > > >> From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
> > > > >> Sent: Friday, December 12, 2014 6:51 PM
> > > > >> To: Zheng, Lv
> > > > >> Cc: Rasmus Villemoes; linux-acpi@vger.kernel.org; devel@acpica.org; linux-kernel@vger.kernel.org
> > > > >> Subject: [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
> > > > >>
> > > > >> The macro __DATE__ and friends is not allowed in the kernel. Also,
> > > > >> including the build time in output doesn't seem to provide any value.
> > > > >>
> > > > >
> > > > > Could you confirm that it is not useful even for the user tools?
> > > > > Please perform the following commands in the kernel source tree
> > > > > 1. stay in tools folder
> > > > > 2. type "make acpi"
> > > > > 3. type "./power/acpi/acpidump -v"
> > > > >
> > > >
> > > > Yeah, it's part of the output, but for what reason? What can userspace
> > > > possibly use that information for?
> > >
> > > I also want to know.
> >
> > I don't see a reason for userspace to know the build date.
> >
> > >
> > > > I can see some utility in printing a
> > > > version number, since that may tell something about the features
> > > > present or absent. The compilation date, on the other hand, seems
> > > > completely useless. Different distros may ship different versions which
> > > > happened to be compiled on the same day, or older versions compiled later.
> > >
> > > If the deletion was done for this reason, IMO, it's acceptable.
> > > So let's wait to see others' feedback.
> > >
> >
> > I'm okay with removing it (the build date) in Linux and ACPICA as well. However
> > the version, which is essentially the release date, is important for the exact
> > reasons already stated.
> >
> > Dave
> _______________________________________________
> Devel mailing list
> Devel@acpica.org
> https://lists.acpica.org/mailman/listinfo/devel
