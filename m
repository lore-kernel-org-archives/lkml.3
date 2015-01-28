Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564AbbA1UiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:38:05 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45511 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761143AbbA1UiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:38:01 -0500
Date: Wed, 28 Jan 2015 18:08:16 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Timur Tabi <timur@codeaurora.org>
Cc: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        Rob Herring <robh@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Linaro-acpi] [PATCH v7 04/17] ARM64 / ACPI: Introduce
 early_param for "acpi" and pass acpi=force to enable ACPI
Message-ID: <20150128180816.GF31752@e104818-lin.cambridge.arm.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <1421247905-3749-5-git-send-email-hanjun.guo@linaro.org>
 <CAOZdJXU2bFR1T4ZnGavvnrUXAp5e=vNt9g6WKX46H8qs1wz-TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOZdJXU2bFR1T4ZnGavvnrUXAp5e=vNt9g6WKX46H8qs1wz-TQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 05:58:54PM +0000, Timur Tabi wrote:
> On Wed, Jan 14, 2015 at 9:04 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> > From: Al Stone <al.stone@linaro.org>
> >
> > Introduce one early parameters "off" and "force" for "acpi", acpi=off
> > will be the default behavior for ARM64, so introduce acpi=force to
> > enable ACPI on ARM64.
> >
> > Disable ACPI before early parameters parsed, and enable it to pass
> > "acpi=force" if people want use ACPI on ARM64. This ensures DT be
> > the prefer one if ACPI table and DT both are provided at this moment.
> 
> What is the reason to assume that DT is preferred over ACPI?  I would
> have thought that if ACPI is present, then it means we're on an ARM64
> server platform, and therefore it should be used.  It seems silly to
> require acpi=force on every ARM64 server platform.

I'm against requiring acpi=force when *only* ACPI tables are present (I
don't like a command line argument to become firmware-kernel ABI), but
otherwise DT takes precedence (it was the first supported booting method
on arm64 and currently it is more mature and feature-rich than ACPI on
arm64).

-- 
Catalin
