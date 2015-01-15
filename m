Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbbAOADb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 19:03:31 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40791 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751796AbbAOADa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 19:03:30 -0500
Date: Thu, 15 Jan 2015 00:03:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, Avi Kivity <avi@cloudius-systems.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] perf symbols: Ignore mapping symbols on aarch64
Message-ID: <20150115000305.GC12302@n2100.arm.linux.org.uk>
References: <1421168344-5363-1-git-send-email-victor.kamensky@linaro.org>
 <20150114112210.GF4050@arm.com>
 <CAA3XUr2KUyafcnUggN7=xGNGSeRkkRtYtxZmwm4UC8sRCGup3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA3XUr2KUyafcnUggN7=xGNGSeRkkRtYtxZmwm4UC8sRCGup3g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 10:38:38AM -0800, Victor Kamensky wrote:
> >From fed6caab410ddcaf487ff23a3908eca129e50b89 Mon Sep 17 00:00:00 2001
> From: Victor Kamensky <victor.kamensky@linaro.org>
> Date: Wed, 14 Jan 2015 07:42:41 -0800
> Subject: [PATCH 3/3] perf symbols: improve abi compliance in arm mapping
>  symbols handling
> 
> Both Arm and Aarch64 ELF ABI allow mapping symbols be in from
> either "$d" or "$d.<any>". But current code that handles mapping
> symbols only deals with the first, dollar character and a single
> letter, case.
> 
> The patch adds handling of the second case with period
> followed by any characters.
> 
> Suggested-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>

I wonder if it would make more sense to re-use the "is_arm_mapping_symbol"
thing which we have in kernel/module.c and scripts/kallsyms.c - it
seems silly to re-invent code which we already have to detect these
symbols.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
