Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab3ENXeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 19:34:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:34438 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758637Ab3ENXeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 19:34:07 -0400
Message-ID: <1368574433.31689.55.camel@pasglop>
Subject: Re: Kernel 3.10-rc1 build warning on 32-bit ppc associated with
 commit 3925f46
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 15 May 2013 09:33:53 +1000
In-Reply-To: <5192584C.1060003@lwfinger.net>
References: <5192584C.1060003@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 10:29 -0500, Larry Finger wrote:
> Hi,
> 
> When building 3.10-rc1 on a PowerBook G4, I get the following warning:

Thanks. Should be fixed now, let me know if it's not.

Cheers,
Ben.

> cc1: warnings being treated as errors
> arch/powerpc/perf/core-book3s.c: In function ‘power_pmu_bhrb_read’:
> arch/powerpc/perf/core-book3s.c:1479: error: integer constant is too large for 
> ‘long’ type
> make[2]: *** [arch/powerpc/perf/core-book3s.o] Error 1
> make[1]: *** [arch/powerpc/perf] Error 2
> make[1]: *** Waiting for unfinished jobs....
>    LD      arch/powerpc/platforms/powermac/built-in.o
>    LD      arch/powerpc/platforms/built-in.o
> make[1]: Leaving directory `/home/finger/wireless-testing'
> make: *** [debian/stamp/build/kernel] Error 2
> 
> The code in question came from commit 3925f46 entitled "powerpc/perf: Enable 
> branch stack sampling framework". The gcc version is 4.4.5 running with a Mint 9 
> distribution.
> 
> I have disabled the "-Werror" switch so that the build can continue. That 
> Kconfig question about disabling WERROR is a bit confusing with its double 
> negative construction.
> 
> Thanks,
> 
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


