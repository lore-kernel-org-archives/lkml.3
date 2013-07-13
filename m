Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab3GMOx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 10:53:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49070 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab3GMOxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 10:53:54 -0400
Message-ID: <51E169F1.5010301@zytor.com>
Date: Sat, 13 Jul 2013 07:53:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 1/3] x86, boot: add mmio serial during compressed boot
References: <1373659660-31123-1-git-send-email-keescook@chromium.org> <20130712203802.GA14702@www.outflux.net> <CAE9FiQWJin8-hXsodo46vhYPMrWiiboEVQySPO-LgXtebYmUzw@mail.gmail.com>
In-Reply-To: <CAE9FiQWJin8-hXsodo46vhYPMrWiiboEVQySPO-LgXtebYmUzw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 11:47 PM, Yinghai Lu wrote:
> 
> for 32 bit, that is ok.
> for 64 bit via 32bit bootloader, arch/x86/boot/compressed/head_64.S
> will set page table for first 4G still ok.
> for 64 bit via 64bit loader, like kexec via bzImage64, First Kernel/Kexec only
> set ident mapping for usable range, so mmio just under 64 is not mapped.
> 
> Looks like we need to update boot.txt to add requirement for 64bit bootloader
> that 0-4G need to be all ident mapping?
> 

I think that is an unrealistic requirement, especially if this is the
sole user.

	-hpa


