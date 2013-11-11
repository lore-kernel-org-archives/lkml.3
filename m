Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab3KKUEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:04:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48262 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab3KKUEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:04:31 -0500
Message-ID: <52813842.40709@zytor.com>
Date: Mon, 11 Nov 2013 12:04:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
References: <1381450698-28710-4-git-send-email-keescook@chromium.org> <tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org> <20131111182046.GA14961@gmail.com> <52812F92.1020006@zytor.com> <CAGXu5j+66dfv_048iDp+ZAv4_sS4si9cHG-8L_4zJ1OHHLxaUw@mail.gmail.com> <52813334.2040405@zytor.com> <20131111195852.GA17408@gmail.com>
In-Reply-To: <20131111195852.GA17408@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 11:58 AM, Ingo Molnar wrote:
>>
>> Use the i8254 if and only if nothing else is available, it isn't safe to
>> touch on some newer systems.
> 
> I concur - the i8254 is probably also a low entry source, given that this 
> all runs early bootup.
> 

Well, it is a 16-bit 1.19318 MHz counter so at least on older systems it
is likely to provide at least a modicum on entropy.  On systems with a
TSC it is likely to be redundant with the TSC.

> In any case there's no excuse for not mixing RDRAND and RDTSC entropy.

	-hpa


