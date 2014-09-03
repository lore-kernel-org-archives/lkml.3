Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbaICV3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:29:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52925 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbaICV3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:29:07 -0400
Message-ID: <54078807.7090408@zytor.com>
Date: Wed, 03 Sep 2014 14:28:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt@console-pimps.org>
CC: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
References: <5405E186.2080406@canonical.com>	<20140902192941.GB3001@console-pimps.org>	<CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>	<5406D0DB.90401@canonical.com>	<CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>	<54073409.6030004@canonical.com>	<CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>	<20140903175948.GH3001@console-pimps.org> <CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com>
In-Reply-To: <CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 12:57 PM, Ard Biesheuvel wrote:
> 
> I guess that is likely to work, I just wasn't aware it existed :-)
> I think adding another visibility(hidden) attribute or 2 would
> complete eliminate the need for GOT fixups, but I guess that is more
> sensitive to compiler versions being recent enough etc.
> The attached (build tested only) patch eliminates all GOT relocations
> under boot/compressed for a 64-bit EFI stub build.
> 

This would be better.  There is no reason to have a GOT in what is
inherently a monolithic binary.

Unfortunately -fvisibility=hidden doesn't seem to be enough.

	-hpa


