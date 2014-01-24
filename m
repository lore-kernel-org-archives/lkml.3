Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaAXQgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:36:51 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50521 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbaAXQgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:36:50 -0500
Date: Fri, 24 Jan 2014 16:35:49 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v5 0/4] perf: AARCH64 arch support
Message-ID: <20140124163548.GH31040@mudshark.cambridge.arm.com>
References: <1390399879-5109-1-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390399879-5109-1-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Wed, Jan 22, 2014 at 02:11:15PM +0000, Jean Pihet wrote:
> Add AARCH64 specific support. This includes the following:
> - AARCH64 perf registers definition and hooks,
> - compat mode registers use, i.e. profiling a 32-bit binary on
>    a 64-bit system,
> - unwinding using the dwarf information from the .debug_frame
>    section of the ELF binary,
> - unwinding using the frame pointer information; in 64-bit and
>    compat modes.
> 
> Note: support for unwinding using the dwarf information in compat
> mode requires some changes to the libunwind code. Those changes
> have been submitted on the libunwind ML and are in discussion.
> 
> Tested on ARMv7, ARMv8 and x86_64 platforms. The compat mode has been
> tested on ARMv8 using statically built 32-bit binaries.

This is look alright to me now, but there are still two blockers:

 (1) Getting the libunwind code merged
 (2) Splitting this into an arch/arm64 series and a tools/perf series, so
     that acme can merge the latter independently (and avoid the mess we had
     last time).

Anyway, for the series:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
