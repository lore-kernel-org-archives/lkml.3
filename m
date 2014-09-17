Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaIQIq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:46:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54409 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaIQIqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:46:54 -0400
Message-ID: <54194A4A.7030104@zytor.com>
Date: Wed, 17 Sep 2014 01:46:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Filipe Brandenburger <filbranden@google.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: Richard Larocque <rlarocque@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michael Davidson <md@google.com>,
        Greg Thelen <gthelen@google.com>, X86 ML <x86@kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>	<CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>	<CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com>	<CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com> <CADU+-uCguxhkw259MefABuzOxvyK_F6bhwza0YhveCCJxEV8wQ@mail.gmail.com>
In-Reply-To: <CADU+-uCguxhkw259MefABuzOxvyK_F6bhwza0YhveCCJxEV8wQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 11:21 PM, Filipe Brandenburger wrote:
> Hi Andy,
> 
> On Tue, Sep 16, 2014 at 10:00 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> I think that the patch should instead tweak the vvar mapping to tell
>> the vdso not to use rdtsc.  It should be based on this:
> 
> I've been working on this approach which extends the vvar from 2 to 3
> pages. The third page would initially be mapped to a zero page but
> then through a prctl a task could replace it with a real page that
> could then be inherited through fork and exec.
> 
> That would make it possible to have per-task vvar contents.
> 
> We could use some of those values as flags to indicate whether vdso
> routines may use RDTSC or not.
> 
> In the future, we're planning to also use that to store clock offsets
> so that we can ensure CLOCK_MONOTONIC works after CRIU migration
> without having to turn off the VDSO or have to always fallback to full
> syscalls on every case.
> 
> Do you think that would be a reasonable way to accomplish that?
> 

Why would we need/want per process vvar contents?  It seems better to
have the code swapped out.

	-hpa


