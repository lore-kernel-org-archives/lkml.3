Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbbAIXNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:13:10 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:62716 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbbAIXNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:13:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jon Masters <jcm@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Al Stone <al.stone@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        "Kangkang.Shen@huawei.com" <Kangkang.Shen@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
Date: Sat, 10 Jan 2015 00:12:17 +0100
Message-ID: <5078266.iyOixLMQK8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54AC0F34.6040500@redhat.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <20150106141630.GG8829@e104818-lin.cambridge.arm.com> <54AC0F34.6040500@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:lkpbTVAsA7pakm7EL8epjoMUqrv6kH9c29fayH3S4UOWXYPAldL
 tzjcADwBuSQpIEDNhvuboNabSm5laJqKWQH5rLc9AcO/nRxSow1Zta3Lyxs4UEyLjPvxuYq
 Ls3hHIl3DR65C2IV1aNhLTh5JePn3vyGPHXgHXszjT3HfwOj7fzZondQmoigCNSvNZ/SaS5
 U00MHDrLw+dpRtgZxELTQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2015 11:37:08 Jon Masters wrote:
> On 01/06/2015 09:16 AM, Catalin Marinas wrote:
> > On Tue, Jan 06, 2015 at 02:05:12PM +0000, Arnd Bergmann wrote:
> >> On Tuesday 06 January 2015 11:29:29 Catalin Marinas wrote:
> >>>>>> We will work on this both on ASWG and linux ACPI driver side, as Dong
> >>>>>> and Charles pointed out, _OSI things can be solved in ACPI spec, when
> >>>>>> that is done, we can modify the kernel driver to fix the problems above.
> >>>>>
> >>>>> Which driver?
> >>>>
> >>>> the ACPICA core driver as you suggested, sorry for the confusion.
> >>>>
> >>>>> What about ACPI_OS_NAME? Would you suggest it is fine to report
> >>>>> "Microsoft Windows NT" on an ARM system? That _OS_ not _OSI.
> >>>>
> >>>> No, not at all. I prefer "Linux"
> >>>> In include/acpi/acconfig.h, when ACPI_OS_NAME defined, it says:
> >>>> "OS name, used for the _OS object.  The _OS object is essentially
> >>>> obsolete,..."
> >>>> for some legacy reasons, we needed  "Microsoft Windows NT", but ACPI
> >>>> for ARM64 on linux is totally new, I think we can change it to
> >>>> "Linux" when CONFIG_ARM64 as you suggested.
> >>>
> >>> We could ignore this change for now if we don't expect the _OS object to
> >>> be used at all. But do we have any other way to check the AML code for
> >>> this? Would FWTS catch such obsolete cases?
> >>
> >> How about just leaving it out? It's clearly not used for anything
> >> good, so I don't see the point in passing either Linux or "Microsoft
> >> Windows NT" here.
> > 
> > Do you mean defining it to NULL (so it ends up as NULL in
> > acpi_gbl_pre_defined_names) or removing "_OS_" entirely from that array?
> > I really can't tell what the implications are.
> 
> Setting it to NULL is almost certainly (99%+ likely IMO) going to result
> in some firmware crashing nastily somewhere.
> 
> I think I've mentioned before that we're using the ACPI patches in an
> early access program for partners that we announced last year. I've
> pinged the team internally and asked that we swiftly change to use
> whatever name is agreed in this thread so that we can get a lot of other
> folks to begin testing with a correctly reported OS name.

If we have to put something in there, I'd vote for keeping the current
string.  It's not clear whether Microsoft would follow the change to
use "Linux" as the _OS_ string, and we probably don't want them to
use incompatible IDs here.

	Arnd
