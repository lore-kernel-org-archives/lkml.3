Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3FYXNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:13:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49417 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab3FYXNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:13:35 -0400
Message-ID: <51CA240C.4000407@zytor.com>
Date: Tue, 25 Jun 2013 16:13:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86, processor-flags: Fix the datatypes and add
 bit number defines
References: <tip-cwckhbrib2aux1qbteaebij0@git.kernel.org> <20130625230727.GB4396@pd.tnic>
In-Reply-To: <20130625230727.GB4396@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 04:07 PM, Borislav Petkov wrote:
> 
> Btw, are you going to need those _BIT defines anywhere else?
> 
> Because if no, you could simply do:
> 
> #define X86_EFLAGS_CF		_BITUL(0) /* Carry Flag */
> 
> and so on, and drop the _BIT defines.
> 

Yes.  I didn't get around to doing this particular bit of the cleanup,
but we have several places where we currently index various bits by
open-coded numbers, especially in assembly code.

	-hpa

