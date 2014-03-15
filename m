Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbaCOAQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 20:16:08 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37132 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbaCOAQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 20:16:05 -0400
Date: Sat, 15 Mar 2014 00:15:42 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Message-ID: <20140315001542.769cff6c@alan.etchedpixels.co.uk>
In-Reply-To: <20140314231832.GA653@thunk.org>
References: <1394746248.27846.3.camel@x230>
	<20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	<1394762250.6416.24.camel@x230.lan>
	<20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	<1394801518.6416.38.camel@x230.lan>
	<20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	<1394820664.26846.18.camel@x230.mview.int.nebula.com>
	<20140314214806.54a3d031@alan.etchedpixels.co.uk>
	<1394834193.1286.11.camel@x230>
	<20140314220840.29a12171@alan.etchedpixels.co.uk>
	<20140314231832.GA653@thunk.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So as far as the narrow question of whether we should accept these
> patches, I think it's a good thing.  Personally, I'm always going to
> be disabling UEFI secure boot (even if it doesn't brick my laptop),
> because for me, the security guarantees it provides isn't worth it.
> But there will be people who want to be able to install Linux on
> Windows 8 certified PC's without tweaking BIOS settings, so merging
> the UEFI secure boot is a good thing, so long as those of use who
> don't want to have anything to do with UEFI secure boot can disable
> it.

I definitely think we want the feature and there are a lot of non UEFI
reasons for this (eg running trusted_kernel() virtual namespaces). I have
three specific issues

1. The implementation is a mess in part because it propogates more policy
all over the place that should be separated. Root cause capable() mixes
policy and activity. Fix suggested in my previous emails (and offer to do
the work)

2. It's likely to lead to more bugs and errors because of the way it has
been done and it doesn't break old code that gets added without
considering the issue. It fails insecure which is bad. Fixed by doing
what I suggested (and offered to do)

3. For things like module options we should be white not blacklisting
'bad' ones.

I've offered to go and fix up the capability stuff - I'm just waiting for
Matthew to actually confirm the question I specifically asked him - does
this solve that bit of his problem. If it does great, I'll go and sort
the capability bits out so we can keep the policy in the right place and
we don't have the kernel festooned with && !trusted_kernel() everywhere.

There is a question of completeness but its very clear we get there with
a combination of two things - whitelisting so we catch stuff we missed
rather than leave holes, and just accepting the reality that it'll take a
few kernels once its upstream until we get them all.

I care about security, we should do the job properly. We have a
further magnitude shift in security needs coming that's going to be at
least equivalent to the scale of shift between the old 'university,
everyone is nice' internet and today.

Alan
