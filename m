Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbaBAU3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 15:29:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33726 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbaBAU3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 15:29:47 -0500
Message-ID: <52ED590D.8090208@zytor.com>
Date: Sat, 01 Feb 2014 12:29:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: stefani@seibold.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
CC: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH 4/4] Add 32 bit VDSO time support for 64 bit kernel
References: <1391268756-10766-1-git-send-email-stefani@seibold.net> <1391268756-10766-5-git-send-email-stefani@seibold.net>
In-Reply-To: <1391268756-10766-5-git-send-email-stefani@seibold.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2014 07:32 AM, stefani@seibold.net wrote:
> 
> This kind of type hacking could be prevent in the future by doing a call to the
> 64 bit code by the following sequence:
> 
> - Compile the arch/x86/vdso/vclock_gettime.c as 64 bit, but only generate
>   the assembler output.
> - Next compile a 32 bit object by including the 64 bit vclock_gettime.s
>   prefixed with .code64
> - At least we need a trampolin code which invokes the 64 bit code and do
>   the API conversation (64 bit longs to 32 bit longs), like the
>   followig snipped:
> 

Honestly, I think the overhead of the mode switch would ruin a lot of
the advantages with the vdso.

	-hpa


