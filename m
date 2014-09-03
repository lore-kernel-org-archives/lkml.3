Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbaICVrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:47:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53127 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792AbaICVrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:47:46 -0400
Message-ID: <54078C74.2060804@zytor.com>
Date: Wed, 03 Sep 2014 14:47:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
References: <5405E186.2080406@canonical.com> <20140902192941.GB3001@console-pimps.org> <CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com> <5406D0DB.90401@canonical.com> <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com> <54073409.6030004@canonical.com> <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com> <20140903175948.GH3001@console-pimps.org>
In-Reply-To: <20140903175948.GH3001@console-pimps.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Any reason we can't reuse the existing GOT fixup code in the early x86
> boot code? We're not executing it before the EFI boot stub atm, which is
> the reason Maarten is hitting these difficulties.
> 
> Maarten, does the following help?
> 
> If not, Ard please go ahead with option #2 above. Overkill yes, but I've
> done the single __attribute__() hacks in other projects and someone
> (usually me) always eventually forgets to tag some instance.
> 

I think we really have two options: either fix up the GOT (which may be
a null operation, if the GOT is empty) or we add a compile-time check
that the GOT is empty, lest we will keep having these problems.

Since the GOT fixup loop is only a few instructions, it doesn't seem to
be all that problematic to just do it -- but make sure we don't end up
running it twice on any code path!

	-hpa

