Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3KOQnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:43:04 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57144 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449Ab3KOQm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:42:59 -0500
Date: Fri, 15 Nov 2013 16:42:13 +0000
From: Will Deacon <will.deacon@arm.com>
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>,
        Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH 0/2] ARM64: perf: add support for the perf registers and
 dwarf unwinding
Message-ID: <20131115164213.GJ19468@mudshark.cambridge.arm.com>
References: <1382108078-8807-1-git-send-email-jean.pihet@linaro.org>
 <CA+b37P0YCPm+4PWJobTOv02M0-mZyf4w02fDrBVYT0wfPL_hpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+b37P0YCPm+4PWJobTOv02M0-mZyf4w02fDrBVYT0wfPL_hpA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 11:04:04AM +0000, Sandeepa Prabhu wrote:
> Hi Jean,
> 
> I have applied this patchset on aarch64 upstream branch,cross-compiled
> for arm64 and try running some tests for hardware breakpoints.
> 
> I cross-compiled perf using linaro toolchain
> "gcc-linaro-aarch64-linux-gnu-4.7-2013.04-20130415_linux" as
>  $ cd tools/perf/
>  $ make LDFLAGS=-static ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
> 
> Copied the static binary to my initrd image and tried running tests to
> place hw_breakpoint on an kernel symbol as:
> 
>  # perf record -e "mem:0xffffffc00013f640:x"

Right, but that's not a valid invocation of perf. You have to give it
something to record. Something like:

# perf record -e mem:0xffffffc00013f640:x -a -- sleep 10

for example.

Will
