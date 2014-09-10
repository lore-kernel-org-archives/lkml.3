Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaIKI7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:59:03 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:47650 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbaIKI60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:58:26 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 04/17] ARM64 / ACPI: Introduce early_param for "acpi"
To: Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <will.deacon@arm.com>
Cc: "jcm@redhat.com" <jcm@redhat.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAErSpo58eWadcyTrsBPAa-QFNmWn5jO7yQGc=N6F6PgNXnXcJA@mail.gmail.com>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
	<1409583475-6978-5-git-send-email-hanjun.guo@linaro.org>
	<CAErSpo6G89mkPgas8Wk3ofq__dUo5MKvBjob5D_w5_GaBJWH0w@mail.gmail.com>
	<540F7BE2.8060403@redhat.com> <20140910130419.GJ28488@arm.com>
	<CAErSpo58eWadcyTrsBPAa-QFNmWn5jO7yQGc=N6F6PgNXnXcJA@mail.gmail.com>
Date: Wed, 10 Sep 2014 22:58:14 +0100
Message-Id: <20140910215815.01B47C41261@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014 07:21:59 -0600, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Sep 10, 2014 at 7:04 AM, Will Deacon <will.deacon@arm.com> wrote:
> 
> > It's blindingly obvious that acpi=off is there to disable ACPI at boot.
> > We either support that option or we don't -- none of this `oh, well you
> > can use it in this specific case I suppose' rubbish. I'm not questioning
> > your use-case, but there's really no need to talk about an `orderly
> > adoption' when all you need to say is that your ACPI is busted and passing
> > acpi=off lets you boot with a devicetree.
> 
> Maybe we should set a taint bit or give some other indication that
> we're using a flag to work around breakage.

Nope. No taint. Maybe a log message, but there are perfectly valid
reasons to use acpi=off, such as the user has a DT for the hardware
that moves all the PM operations into the kernel-proper to tune for a
very specific use case. This moves outside the support envelope, but
that doesn't make it a bad thing or the wrong thing to do.

g.

