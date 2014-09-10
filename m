Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaIJQMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:12:03 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:41703 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaIJQMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:12:00 -0400
MIME-Version: 1.0
In-Reply-To: <541071CF.9030901@gmail.com>
References: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>
	<541071CF.9030901@gmail.com>
Date: Wed, 10 Sep 2014 12:11:58 -0400
Message-ID: <CAJ5Y-eYRiq8ZFuKQHR0cDBWQfp7eEQLVfzvXNHpxOwEFQZeEeg@mail.gmail.com>
Subject: Re: [RFC v1 0/6] CPPC as a PID backend
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "rwells@codeaurora.org" <rwells@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2014 11:44, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> Hi Ashwin,

Hi Dirk,

>
> I think the CPPC based driver should be a separate driver.
>
> We made the conscious decision to not use any of the ACPI mechanisms
> to enumerate or control P state selection.  Experience over the years
> has shown that the quality/accuracy of the BIOS/ACPI implementations
> vary widely across OEM's and platform types from a single OEM. Features
> that always work on a server platform from a given OEM may not work or
> provide bad information on client platforms for example.
>
> Another reason for doing intel_pstate was to be able to land intel specific
> features and fixes without breaking other architectures as the power
> management capabilities of the platform evolve. As processors that support
> Hardware P states (HWP) as described in section 14.4 of the current SDM
> come into the market intel_pstate will change to not doing much other
> than enabling HWP and providing an interface to forward user configuration
> requests to the processor if the user chooses to enable HWP otherwise the
> current mechanisms will be used.  This is why the intel_pstate sysfs
> interface is the way it is to be able to map cleanly to HWP and provide
> an abstract interface going forward.
>
> Having separate drivers allows the system integrator/user to select the
> most appropriate mechanism for their system.
>
> --Dirk

With the current split I think you will still be able to maintain
Intel specific changes for the future in the backend driver. The PID
algorithm seems platform independent anyway and the PID knobs are
exported to userspace for platform specific tuning. The Intel backend
driver should be unaffected by the CPPC (ACPI) backend. We can also
make them mutually exclusive at runtime.

Or are you suggesting using PID + CPPC as another driver? IIUC, that
would lead to a lot of redundancy.

Cheers,
Ashwin
