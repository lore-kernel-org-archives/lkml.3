Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaHKRw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:52:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54656 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbaHKRw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:52:28 -0400
Message-ID: <53E9028E.2070709@zytor.com>
Date: Mon, 11 Aug 2014 10:51:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Shaun Ruffell <sruffell@digium.com>, Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 11/15] purgatory: Core purgatory functionality
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com> <1403814824-7587-12-git-send-email-vgoyal@redhat.com> <20140811174017.GD12610@digium.com>
In-Reply-To: <20140811174017.GD12610@digium.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 10:40 AM, Shaun Ruffell wrote:
> FYI, it looks like the following patch (committed in
> 8fc5b4d4121c95482b2583) adds a new requirement to use at least gcc
> 4.4 to build the kernel?

Well, to build the kernel with that particular new functionality
enabled, yes.

However...

> The above "-mcmodel=large" compiler flag produces the following output on GCC 4.1.2.
> 
>   $ make modules_prepare ; gcc --version
>     CHK     include/config/kernel.release
>     CHK     include/generated/uapi/linux/version.h
>     CHK     include/generated/utsrelease.h
>     CC      arch/x86/purgatory/purgatory.o
>   arch/x86/purgatory/purgatory.c:1: sorry, unimplemented: code model ‘large’ not supported yet
>   make[1]: *** [arch/x86/purgatory/purgatory.o] Error 1
>   make: *** [archprepare] Error 2
>   gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-54)
>   Copyright (C) 2006 Free Software Foundation, Inc.
>   This is free software; see the source for copying conditions.  There is NO
>   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> I did a quick search for a discussion the indicates this compiler is now
> officially too old to build the kernel but did not find one.
> 
> If this is required, maybe Documentation/Changes needs to be updated
> with the new minimum required version?

... I'm having a very, very hard time to picture a reason why the
"large" model would be necessary or even desirable for the purgatory
code.  The "small PIC" model seem to fit much better...

	-hpa


