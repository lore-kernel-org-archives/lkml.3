Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab3BLXwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:52:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:13652 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab3BLXwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:52:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,652,1355126400"; 
   d="scan'208";a="201666287"
Message-ID: <511AD5D4.8000309@linux.intel.com>
Date: Tue, 12 Feb 2013 15:52:52 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, "H.J. Lu" <hjl.tools@gmail.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm: Redesign get_user with a __builtin_choose_expr
 hack
References: <511A8922.6050908@zytor.com> <tip-3578baaed4613a9fc09bab9f79f6ce2ac682e8a3@git.kernel.org> <CA+55aFzVSY6G3ZDy7YhwGd2k+OBtpDZaobw8awCeyZsaAqHDVw@mail.gmail.com> <511ACDFB.1050707@zytor.com> <CA+55aFzU=zvjBPRSKCYHdf3ET-oq6s66e_PHHGcDwf3sJx+j+A@mail.gmail.com>
In-Reply-To: <CA+55aFzU=zvjBPRSKCYHdf3ET-oq6s66e_PHHGcDwf3sJx+j+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 03:49 PM, Linus Torvalds wrote:
> On Tue, Feb 12, 2013 at 3:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> Yes, but there doesn't seem to be any other way to do this.  gcc won't
>> even allow "=cd" even if we know the variable is 64 bits, even though
>> "=A" is documented to be equivalent to "=da".
> 
> No, "=da" means value "in edx _or_ %eax". Not the same as "A".
> 

Actually, if you look at how gcc implements them, they are the same, and
if you are luckless enough to try to use a 32-bit value with an "A"
constraint you have it end up in either %eax or %edx.

However, they seem to have added some additional linting which prohibits
the compound form.  I'm not sure it would have worked anyway since we
need the two-register bit to be conditional.

> But you're right, there's nothing similar for %ebx:%ecx. I thought
> there was. I was really sure we did something special for 64-bit adc
> etc.
> 
>> Let me know what you think.
> 
> I guess we don't have any choice. And the other cleanups certainly look good.

OK, will commit the comment.  We can add the additional copy if we need it.

	-hpa


