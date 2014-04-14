Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaDNPrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:47:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47283 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbaDNPqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:46:06 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140414072755.GA719@gmail.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com> <53483896.9070404@linux.intel.com> <20140414072755.GA719@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 14 Apr 2014 08:45:36 -0700
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Brian Gerst <brgerst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>
Message-ID: <3d21e234-32f4-46bf-a659-ba36870e0161@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For both of these, though, it is really kind of broken that it is a global switch, whereas typically only one application on the whole system needs it, so it would be much better to have application-specific controls.  How to do that is another matter...

On April 14, 2014 12:27:56 AM PDT, Ingo Molnar <mingo@kernel.org> wrote:
>
>* H. Peter Anvin <hpa@linux.intel.com> wrote:
>
>> On 04/11/2014 11:41 AM, Linus Torvalds wrote:
>> > 
>> > Ok, so you actually do this on x86-64, and it currently works? For
>> > some reason I thought that 16-bit windows apps already didn't work.
>> > 
>> 
>> Some will work, because not all 16-bit software care about the upper
>> half of ESP getting randomly corrupted.
>> 
>> That is the "functionality bit" of the problem.  The other bit, of
>> course, is that that random corruption is the address of the kernel
>stack.
>> 
>> > Because if we have working users of this, then I don't think we can
>do
>> > the "we don't support 16-bit segments", or at least we need to make
>it
>> > runtime configurable.
>> 
>> I'll let you pick what the policy should be here.  I personally 
>> think that we have to be able to draw a line somewhere sometimes 
>> (Microsoft themselves haven't supported running 16-bit binaries for 
>> several Windows generations now), but it is your policy, not mine.
>
>I think the mmap_min_addr model works pretty well:
>
> - it defaults to secure
>
> - allow a security policy to grant an exception to a known package, 
>   built by the distro
>
> - end user can also grant an exception
>
>This essentially punts any 'makes the system less secure' exceptions 
>to the distro and the end user.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
