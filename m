Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258Ab3KMJ62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 04:58:28 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56231 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758825Ab3KMJ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 04:58:25 -0500
MIME-Version: 1.0
X-Originating-IP: [218.164.102.165]
In-Reply-To: <CACVXFVPQfUtrc4r4cS9J+6q5Z6hGZDgafH=M_6JfrzrAUGJOHw@mail.gmail.com>
References: <CACVXFVNHryPXy2NQhPwXkoCeLUXQSgrWmgBkMNtGD_=X_62_5Q@mail.gmail.com>
	<CAFRkauDGiy3yZOwKFWMEJvYUe0OoXMEZHKaxogZHdgzMxexdHA@mail.gmail.com>
	<CACVXFVMAnewCkSNNke3kf1-yO+JCc_HBRp8iaLBPJ+14G79Haw@mail.gmail.com>
	<87y54vzszo.fsf@rustcorp.com.au>
	<CAFRkauBYUq3UAjqLvkuDVEz5BVyDpC0DuVRGTe4K+kcoCX17GA@mail.gmail.com>
	<CACVXFVMvvG1unnR0rsmBMdp9p19Q3JRbURxZF-UWxvrThDPKTw@mail.gmail.com>
	<CAFRkauCW3FDSuh4t0gvmSWH1m0+qaG0XSoBxmk30Wq1FMy7iFw@mail.gmail.com>
	<CACVXFVMzOzD+D-MQCUBvC80d4zS-TJfcucKuUvzerGs6gT1fEg@mail.gmail.com>
	<CACVXFVOnVXcVdRCm=OfPjpvvWCiXi8GRV+9ViOGmSZ3tTf6WDg@mail.gmail.com>
	<528110B1.4060402@arm.com>
	<20131111193236.GB16735@n2100.arm.linux.org.uk>
	<CACVXFVPQfUtrc4r4cS9J+6q5Z6hGZDgafH=M_6JfrzrAUGJOHw@mail.gmail.com>
Date: Wed, 13 Nov 2013 17:58:24 +0800
Message-ID: <CAFRkauACb7wPdisp-PEic_-ko5MhhnAyigcpg5gfjLEFUuJqGw@mail.gmail.com>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
From: Axel Lin <axel.lin@ingics.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/12 Ming Lei <tom.leiming@gmail.com>:
> On Tue, Nov 12, 2013 at 3:32 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Mon, Nov 11, 2013 at 05:15:29PM +0000, Jonathan Austin wrote:
>>> I've tested the patch below and it solves the ARM side of things - so
>>> gives you an option other than a complete revert. Happy to put this in to
>>> RMK's patch system if you'd prefer not to have to revert and he's happy
>>> with the patch.
>>
>> I think this is the right solution because it then means that this symbol
>> has the same meaning whether on MMU or !MMU - and getting rid of these
>> kinds of gratuitous variances are the only way that !MMU is going to
>> become less fragile.
>
> The patch only fixes problem on arm, and other !MMU&&!ARM archs
> should be affected too.
>
> Also there is no CONFIG_PAGE_OFFSET defined for some ARCHs,
> such as 64bit ARCHs.
>
> Currently, I suggest to filter only on ARM as attachment patch if we plan
> to merge Jonathan's patch, otherwise a more complicated approach has
> to be figured out  to do the filter(such as, define a readonly symbol in
> kernel to store PAGE_OFFSET, and let scripts/kallsyms use it for
> filtering).

Hi Ming,
You missed "; then" in the end of if statement in your patch.

So I got below error with your patch:
scripts/link-vmlinux.sh: line 87: syntax error near unexpected token `fi'
make: *** [vmlinuxclean] Error 2

Regards,
Axel
