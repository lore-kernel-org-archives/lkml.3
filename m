Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbaIQQs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:48:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59180 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756193AbaIQQsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:48:55 -0400
Date: Wed, 17 Sep 2014 17:48:50 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v4 01/18] ARM64: Move the init of cpu_logical_map(0)
 before unflatten_device_tree()
Message-ID: <20140917164850.GB7983@leverpostej>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <1410530416-30200-2-git-send-email-hanjun.guo@linaro.org>
 <20140915061632.GA26649@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915061632.GA26649@localhost>
Thread-Topic: [PATCH v4 01/18] ARM64: Move the init of cpu_logical_map(0)
 before unflatten_device_tree()
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 07:16:32AM +0100, Olof Johansson wrote:
> On Fri, Sep 12, 2014 at 09:59:59PM +0800, Hanjun Guo wrote:
> > It always make sense to initialize CPU0's logical map entry from the
> > hardware values, so move the initialization of cpu_logical_map(0)
> > before unflatten_device_tree() which is needed by ACPI code later.
> > 
> > Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> 
> Acked-by: Olof Johansson <olof@lixom.net>
> 
> With or without needs for ACPI, I don't think there's any reason for
> this code to not go in now.

I can see this being of use to psci_init() where I'd like to check
MIGRATE_INFO_TYPE and MIGRATE_INFO_UP_CPU early on for systems with PSCI
0.2+. So moving it at least that early sounds good to me.

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.
