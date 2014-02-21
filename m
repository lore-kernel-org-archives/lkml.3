Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaBUDns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 22:43:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48654 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaBUDnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 22:43:47 -0500
Message-ID: <5306CB60.3070302@zytor.com>
Date: Thu, 20 Feb 2014 19:43:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: "m" constraints, jumps, and alternatives
References: <53068F5C.9000008@zytor.com>	<CA+55aFw211LMAk=CSgOo26a-1QqpSEjmJZNJ4TSnbPnJUjPwOQ@mail.gmail.com> <CAMzpN2ie6ALLmL_A+eaQ54aKaHZkwtTr+AqGL6ThHM1Ay+VfFg@mail.gmail.com>
In-Reply-To: <CAMzpN2ie6ALLmL_A+eaQ54aKaHZkwtTr+AqGL6ThHM1Ay+VfFg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 07:30 PM, Brian Gerst wrote:
> 
> The percpu code uses %P to force absolute addressing mode, instead of
> rip-relative.
> 

   P -- if PIC, print an @PLT suffix.

Clearly it has more effects than that... as the code does reveal:

      /* Avoid (%rip) for call operands.  */
      if (CONSTANT_ADDRESS_P (x) && code == 'P'
          && !CONST_INT_P (x))

That should work... in the probably extremely rare case that any of
these references go to global addresses then they spend an extra byte
(and a little more work during kASLR relocation or module insertion).

	-hpa

