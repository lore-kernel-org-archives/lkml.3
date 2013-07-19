Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3GSXZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:25:25 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:57445 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751308Ab3GSXZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:25:23 -0400
Date: Sat, 20 Jul 2013 09:24:59 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak <ak@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module
 dependency.
Message-ID: <20130719232459.GA18039@gondor.apana.org.au>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>
 <2493652.fjZLqTL8IF@vostro.rjw.lan>
 <1374257329.22432.382.camel@schen9-DESK>
 <4295105.1txhDL4OOg@vostro.rjw.lan>
 <20130719231630.GC1701@kroah.com>
 <51E9C9E5.2060602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E9C9E5.2060602@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 04:21:09PM -0700, H. Peter Anvin wrote:
>
> The issue here seems to be the dynamic binding nature of the crypto
> subsystem.  When something needs crypto, it will request the appropriate
> crypto module (e.g. crct10dif), which may race with detecting a specific
> hardware accelerator based on CPUID or device information (e.g.
> crct10dif_pclmul).
> 
> RAID has effectively the same issue, and we just "solved" it by
> compiling in all the accelerators into the top-level module.

I think for crypto the simplest solution is to not do CPUID-based
loading.  Then crypto users will simply load the module alias which
causes modprobe to load all modules providing that alias.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
