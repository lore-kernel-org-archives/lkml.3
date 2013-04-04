Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764857Ab3DDUXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:23:43 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:59261 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764774Ab3DDUXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:23:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAKyRK=iZeYv8MPa2tLfRRTmNX2WQsT+t3UAu_wy3uT9TiZokgA@mail.gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
	<1365106055-22939-4-git-send-email-keescook@chromium.org>
	<515DDEC0.9000109@zytor.com>
	<CAKyRK=iZeYv8MPa2tLfRRTmNX2WQsT+t3UAu_wy3uT9TiZokgA@mail.gmail.com>
Date: Thu, 4 Apr 2013 13:23:41 -0700
Message-ID: <CAKyRK=ic3QHOLKen=jxgeEN5mVVj_Gyt-1wXOniKNgO75f80Qw@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
From: Julien Tinnes <jln@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 1:19 PM, Julien Tinnes <jln@google.com> wrote:
> On Thu, Apr 4, 2013 at 1:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 04/04/2013 01:07 PM, Kees Cook wrote:
>>> However, the benefits of
>>> this feature in certain environments exceed the perceived weaknesses[2].
>>
>> Could you clarify?
>
> I think privilege reduction in general, and sandboxing in particular,
> can make KASLR even more useful. A lot of the information leaks can be
> mitigated in the same way as attack surface and vulnerabilities can be
> mitigated.

Case in point:
- leaks of 64 bits kernel values to userland in compatibility
sub-mode. Sandboxing by using seccomp-bpf can restrict a process to
the 64-bit mode API.
- restricting access to the syslog() system call

Julien
