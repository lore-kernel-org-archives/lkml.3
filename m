Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbbAOQxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:53:20 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:63660 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbbAOQxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:53:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-acpi@lists.linaro.org
Cc: Jon Masters <jcm@redhat.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
Date: Thu, 15 Jan 2015 17:52:31 +0100
Message-ID: <2277974.2klgILPa2Q@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54B7E21E.2000901@redhat.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <CACxGe6tjiE6u8i-1PHYzX2cOhxJkYN3cV9mqhCHRSMRdOQRfzg@mail.gmail.com> <54B7E21E.2000901@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:knY195dZInYU3AKSusZfy0+f6rhw+LOK9QtkfieiVf+796ILtt2
 mCFVMfJrNupcY8uIjvvOpFywYvKkJ6tgIZt+MQ4P8yDXSspN6GelIKxMrIjLKYda/FTiDsa
 m7uRwHW9pcKKKFDTc8amCHRfoUovNJHevTsdxL+7mcP/PlUVKjiPs8x/mtU1VHtkBYqb18X
 qlKT8XkpBXyaXjVx0O9fA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2015 10:51:58 Jon Masters wrote:
> On 01/15/2015 09:10 AM, Grant Likely wrote:
> > On Tue, Jan 6, 2015 at 1:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> For drivers merged upstream, I would insist that every driver merged
> >> for an ARM64 platform has a documented DT binding that is used in the
> >> driver.
> > 
> > That's a dumb rule. It will result in untested DT code paths being
> > thrown into drivers just too meet the rules rather than on whether or
> > not they will actually be used. It's fine to allow driver authors to
> > only implement the ACPI code path if that is what they are working
> > with. We can *always* add a DT path to the driver when it is needed.
> 
> It gets worse. There *will* be large numbers of ACPI only ARM servers
> landing over the coming year. Not only would DT code be untested, but
> insisting on keeping e.g. a DSDT and DT in sync is never going to work
> anyway. Already we have early stage servers that contain a DT used for
> bringup that is subsequently not being updated as often as the ACPI
> tables (those systems are now booting exclusively in labs with ACPI).
> Eventually, I am going to push for the DT data to be removed from these
> systems rather than have out of date unmaintained DT data in firmware.

We will of course be able to relax the rule once ACPI has stabilized on
ARM64. At the moment, we haven't even agreed on how to represent basic
devices, so things are in flux and there is no way for a BIOS writer
to ship an image that we will guarantee to support in the long run.

At some point after we are reasonably sure we are able to keep supporting
all existing systems that are working with that kernel, we can take
support for new systems without having DT by default, and also support
booting those without acpi=force, which is related to this question.

	Arnd
