Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbbAFOGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:06:12 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:54387 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbbAFOGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:06:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Al Stone <al.stone@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "jcm@redhat.com" <jcm@redhat.com>,
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
Date: Tue, 06 Jan 2015 15:05:12 +0100
Message-ID: <2647669.mQf6pODdjV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150106112929.GB8829@e104818-lin.cambridge.arm.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <54ABC2CB.6@linaro.org> <20150106112929.GB8829@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:rRT6gG3JQqrZm/6dpw2l1Y94JIO1PjgEdH6w79A2fIKLaCkHCNm
 JtjYGgAXIi5F/vC9wrtCGg2cGMsTfysQtvc+5Kb0sZynADQYpKURG/LQnqzjX2vRTwPKNX/
 urLKB2fKZS1R3/wU7qZsHs7LyCkdZtmDfMHjv1t6iZBw7H3KyFA3c2HcibDiJmZdKHnBh/G
 TBbGZPCmKIuNf8YjNaLnw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2015 11:29:29 Catalin Marinas wrote:
> > >> We will work on this both on ASWG and linux ACPI driver side, as Dong
> > >> and Charles pointed out, _OSI things can be solved in ACPI spec, when
> > >> that is done, we can modify the kernel driver to fix the problems above.
> > >
> > > Which driver?
> > 
> > the ACPICA core driver as you suggested, sorry for the confusion.
> > 
> > > What about ACPI_OS_NAME? Would you suggest it is fine to report
> > > "Microsoft Windows NT" on an ARM system? That _OS_ not _OSI.
> > 
> > No, not at all. I prefer "Linux"
> > In include/acpi/acconfig.h, when ACPI_OS_NAME defined, it says:
> > "OS name, used for the _OS object.  The _OS object is essentially
> > obsolete,..."
> > for some legacy reasons, we needed  "Microsoft Windows NT", but ACPI
> > for ARM64 on linux is totally new, I think we can change it to
> > "Linux" when CONFIG_ARM64 as you suggested.
> 
> We could ignore this change for now if we don't expect the _OS object to
> be used at all. But do we have any other way to check the AML code for
> this? Would FWTS catch such obsolete cases?

How about just leaving it out? It's clearly not used for anything
good, so I don't see the point in passing either Linux or "Microsoft
Windows NT" here.

	Arnd
