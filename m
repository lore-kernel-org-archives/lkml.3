Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaBIUMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:12:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53342 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbaBIUMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:12:45 -0500
Message-ID: <52F7E0DC.7070103@zytor.com>
Date: Sun, 09 Feb 2014 12:11:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>, Andi Kleen <ak@linux.intel.com>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com,
        Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH v13 8/9] Add 32 bit VDSO time support for 32 bit kernel
References: <1391894951-6381-1-git-send-email-stefani@seibold.net>	 <1391894951-6381-9-git-send-email-stefani@seibold.net>	 <20140209052230.GL12219@tassilo.jf.intel.com>	 <1391933453.1014.20.camel@wall-e.seibold.net>	 <20140209100536.GM12219@tassilo.jf.intel.com> <1391946317.18067.11.camel@wall-e.seibold.net>
In-Reply-To: <1391946317.18067.11.camel@wall-e.seibold.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 03:45 AM, Stefani Seibold wrote:
>>
>> Yes the syscall does, but the vsyscall stub does not (for the !0x80 case)
> 
> I cross check all kinds of vsyscall and all do save the ECX registers. 
> 
> So IMHO i see no register modification other than EAX, which is declared
> as the output register in the asm() directive.
> 

That is, indeed, correct, as the 32-bit vsyscall stubs are explicitly
designed to be drop-in replacements for the int $0x80 instruction.

	-hpa


