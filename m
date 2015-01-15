Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbbAOHfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:35:09 -0500
Received: from smtprelay2.synopsys.com ([198.182.60.111]:53801 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbbAOHfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 02:35:07 -0500
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: "clark.williams@gmail.com" <clark.williams@gmail.com>,
        "jkacur@redhat.com" <jkacur@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "Vineet Gupta" <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH] Makefile: allow building selected tests with non-NPTL
 toolchain
Thread-Topic: [PATCH] Makefile: allow building selected tests with non-NPTL
 toolchain
Thread-Index: AQHP/LZZFI6XIB+rvEeDZYoOGgll9ZzBIVgA
Date: Thu, 15 Jan 2015 07:35:01 +0000
Message-ID: <1421307300.3008.2.camel@synopsys.com>
References: <1415603814-7682-1-git-send-email-abrodkin@synopsys.com>
In-Reply-To: <1415603814-7682-1-git-send-email-abrodkin@synopsys.com>
Reply-To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.121.8.131]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <D662DF546FE0D74AA4ACBA4C3259D997@internal.synopsys.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clark, John,

On Mon, 2014-11-10 at 10:16 +0300, Alexey Brodkin wrote:
> Some architectures are still stuck with non-NPTL toolchains.
> These are for example ARC, Blackfin, Xtensa etc.
> 
> Still rt-tests are very good benchmarks and it would be good to enable use of
> at least selected (those that will be built) tests on those architectures.
> 
> This change makes it possible to only build subset of tests that don't require
> NPTL calls.
> 
> By default behavior is not modified - all tests are built, but if one wants
> to build with non-NPTL toolchain just add "HAVE_NPTL=no" in command line
> or modify "HAVE_NPTL" variable right in Makefile and execute "make".
> 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Cc: Clark Williams <clark.williams@gmail.com>
> ---
>  Makefile | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 318a5c6..675edf7 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,8 +1,13 @@
>  VERSION_STRING = 0.89
>  
> -sources = cyclictest.c signaltest.c pi_stress.c rt-migrate-test.c	\
> -	  ptsematest.c sigwaittest.c svsematest.c pmqtest.c sendme.c 	\
> -	  pip_stress.c hackbench.c
> +HAVE_NPTL ?= yes
> +
> +ifeq ($(HAVE_NPTL),yes)
> +sources = cyclictest.c pi_stress.c pip_stress.c pmqtest.c rt-migrate-test.c
> +endif
> +
> +sources += signaltest.c ptsematest.c sigwaittest.c svsematest.c sendme.c \
> +	  hackbench.c
>  
>  TARGETS = $(sources:.c=)

I'm wondering if there's a chance to get this patch reviewed and if
there're no objections applied?

Regards,
Alexey
