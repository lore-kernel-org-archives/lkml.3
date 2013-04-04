Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764848Ab3DDU2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:28:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57422 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764829Ab3DDU22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:28:28 -0400
Message-ID: <515DE24D.3080507@zytor.com>
Date: Thu, 04 Apr 2013 13:27:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Julien Tinnes <jln@google.com>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-4-git-send-email-keescook@chromium.org> <515DDEC0.9000109@zytor.com> <CAKyRK=iZeYv8MPa2tLfRRTmNX2WQsT+t3UAu_wy3uT9TiZokgA@mail.gmail.com> <CAKyRK=ic3QHOLKen=jxgeEN5mVVj_Gyt-1wXOniKNgO75f80Qw@mail.gmail.com>
In-Reply-To: <CAKyRK=ic3QHOLKen=jxgeEN5mVVj_Gyt-1wXOniKNgO75f80Qw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 01:23 PM, Julien Tinnes wrote:
> On Thu, Apr 4, 2013 at 1:19 PM, Julien Tinnes <jln@google.com> wrote:
>> On Thu, Apr 4, 2013 at 1:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 04/04/2013 01:07 PM, Kees Cook wrote:
>>>> However, the benefits of
>>>> this feature in certain environments exceed the perceived weaknesses[2].
>>>
>>> Could you clarify?
>>
>> I think privilege reduction in general, and sandboxing in particular,
>> can make KASLR even more useful. A lot of the information leaks can be
>> mitigated in the same way as attack surface and vulnerabilities can be
>> mitigated.
> 
> Case in point:
> - leaks of 64 bits kernel values to userland in compatibility
> sub-mode. Sandboxing by using seccomp-bpf can restrict a process to
> the 64-bit mode API.
> - restricting access to the syslog() system call
> 

That doesn't really speak to the value proposition.  My concern is that
we're going to spend a lot of time chasing/plugging infoleaks instead of
tackling bigger problems.

8 bits of entropy is not a lot.

	-hpa

