Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab3GSXhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:37:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:29851 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab3GSXhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:37:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,705,1367996400"; 
   d="scan'208";a="373446480"
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module
 dependency.
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak <ak@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
In-Reply-To: <20130719232459.GA18039@gondor.apana.org.au>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>
	 <2493652.fjZLqTL8IF@vostro.rjw.lan>
	 <1374257329.22432.382.camel@schen9-DESK>
	 <4295105.1txhDL4OOg@vostro.rjw.lan> <20130719231630.GC1701@kroah.com>
	 <51E9C9E5.2060602@zytor.com>  <20130719232459.GA18039@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Jul 2013 16:37:13 -0700
Message-ID: <1374277033.22432.384.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-20 at 09:24 +1000, Herbert Xu wrote:
> On Fri, Jul 19, 2013 at 04:21:09PM -0700, H. Peter Anvin wrote:
> >
> > The issue here seems to be the dynamic binding nature of the crypto
> > subsystem.  When something needs crypto, it will request the appropriate
> > crypto module (e.g. crct10dif), which may race with detecting a specific
> > hardware accelerator based on CPUID or device information (e.g.
> > crct10dif_pclmul).
> > 
> > RAID has effectively the same issue, and we just "solved" it by
> > compiling in all the accelerators into the top-level module.
> 
> I think for crypto the simplest solution is to not do CPUID-based
> loading.  Then crypto users will simply load the module alias which
> causes modprobe to load all modules providing that alias.
> 
> Cheers,

Herbert,

I've tried the module alias approach (see my earlier mail with patch) 
but it didn't seem to load things properly.  Can you check to see if 
there's anything I did incorrectly.

Tim

