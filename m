Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3KHQjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:39:51 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:39908 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076Ab3KHQju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:39:50 -0500
MIME-Version: 1.0
In-Reply-To: <1464650.041viV29xe@sifl>
References: <20131107174746.GA22344@www.outflux.net> <1383850597.2938.52.camel@localhost>
 <CALCETrVgwMto=5Rn34dDOLrmzLargvs4QxCdPWdEvd=UZhg_Jg@mail.gmail.com> <1464650.041viV29xe@sifl>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 8 Nov 2013 08:39:29 -0800
Message-ID: <CALCETrWx0T28jdC-pW5xTPhRYJsbp+byeF5CAwZh0gXdd09RNQ@mail.gmail.com>
Subject: Re: [libseccomp-discuss] [PATCH v2] seccomp: not compatible with ARM OABI
To: Paul Moore <pmoore@redhat.com>
Cc: libseccomp-discuss@lists.sourceforge.net, Eric Paris <eparis@redhat.com>,
        James Hogan <james.hogan@imgtec.com>, Will Drewry <wad@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 8, 2013 at 8:29 AM, Paul Moore <pmoore@redhat.com> wrote:
> On Thursday, November 07, 2013 11:05:26 AM Andy Lutomirski wrote:
>> On Thu, Nov 7, 2013 at 10:56 AM, Eric Paris <eparis@redhat.com> wrote:
>>
>> > Isn't x32 similarly screwy?  Does it work because the syscall numbers
>> > are different?
>>
>> Yes (from reading the code -- I haven't actually tried it).
>
> I've got a x32 VM that I boot occasionally to test seccomp/libseccomp.  For
> the purposes of seccomp it looks exactly like x86_64, including sharing the
> same AUDIT_ARCH_X86_64 value, the only difference being the syscall number
> offset ... Assuming you're using kernel 3.9 or later.  Previous kernels had a
> bug which stripped the x32 syscall offset so it was impossible to distinguish
> from x86_64 and x32 with seccomp.  See the following commit for the details:

Ooh -- where did you get this?  (I imagine I could debootstrap such a
beast and then just chroot / nspawn / schroot in, but if there are
readily available images, that would be great.  Fedora doesn't seem to
have much x32 support.)

--Andy
