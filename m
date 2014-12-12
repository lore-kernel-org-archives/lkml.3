Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967433AbaLLUtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:49:12 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:33666 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345AbaLLUtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:49:11 -0500
MIME-Version: 1.0
In-Reply-To: <548B4FBE.5090101@sr71.net>
References: <20141212191213.579887D2@viggo.jf.intel.com> <548B4E75.5010507@amacapital.net>
 <548B4FBE.5090101@sr71.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 12 Dec 2014 12:48:49 -0800
Message-ID: <CALCETrW4f3EUYGG_zyzb7sZBXaoW3eHMpTn3dd3WpDgJq2HjtA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] x86, mpx: Support 32-bit binaries on 64-bit kernels
To: Dave Hansen <dave@sr71.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 12:27 PM, Dave Hansen <dave@sr71.net> wrote:
> On 12/12/2014 12:22 PM, Andy Lutomirski wrote:
>> On 12/12/2014 11:12 AM, Dave Hansen wrote:
>>> This is 3.20 material.  I'm hoping to get some comments early
>>> in case folks have some issues with the way it's being done.
>>>
>>> The MPX hardware structures differ in layout in 32 and 64-bit
>>> mode.  A 32-bit binary running on a 64-bit kernel needs the
>>> 32-bit structures, so we need code which switches between
>>> the two modes.
>>
>> The OS community figured out years ago that you aren't supposed to do
>> this.  Did everyone forget to tell the hardware people?
>
> What is your concern with it, exactly?
>
> You want the same size structures with the same format for 32-bit and
> 64-bit modes?

Yes.  Especially because programs can switch between 32-bit and 64-bit
mode entirely in userspace.  I don't know whether any do in practice,
but programs *can*.

Or better yet: Intel could have skipped supporting it at all in 32-bit
mode.  Isn't mpx somewhat of an address space hog anyway?

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
