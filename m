Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbaIDH3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:29:54 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:50897 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaIDH3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:29:53 -0400
Date: Thu, 4 Sep 2014 08:29:49 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
Message-ID: <20140904072949.GI3001@console-pimps.org>
References: <5405E186.2080406@canonical.com>
 <20140902192941.GB3001@console-pimps.org>
 <CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>
 <5406D0DB.90401@canonical.com>
 <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>
 <54073409.6030004@canonical.com>
 <CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>
 <20140903175948.GH3001@console-pimps.org>
 <54078C74.2060804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54078C74.2060804@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep, at 02:47:32PM, H. Peter Anvin wrote:
> 
> I think we really have two options: either fix up the GOT (which may be
> a null operation, if the GOT is empty) or we add a compile-time check
> that the GOT is empty, lest we will keep having these problems.
> 
> Since the GOT fixup loop is only a few instructions, it doesn't seem to
> be all that problematic to just do it -- but make sure we don't end up
> running it twice on any code path!

Urgh, I totally did make it run twice. My bad.

-- 
Matt Fleming, Intel Open Source Technology Center
