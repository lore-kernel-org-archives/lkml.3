Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051Ab3DZJCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:02:19 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35910 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab3DZJCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:02:16 -0400
MIME-Version: 1.0
In-Reply-To: <517A3FA0.8030702@intel.com>
References: <201304252144.r3PLihDe025383@terminus.zytor.com>
	<CA+55aFxxWXrQU4oZUbHOBBkvtF=pSxMvyF6sYU9xpSDarWV-=Q@mail.gmail.com>
	<1366928604.9976.3.camel@x230>
	<CANN689EH-VyDefawtKdY=cVQNdZP1xN7cV4bDgXvYeniSCkvqA@mail.gmail.com>
	<5179B435.1000404@zytor.com>
	<CANN689EaFu32GKNj-U41ykGpNJekBL2=w92P1pSkETuKAffJDQ@mail.gmail.com>
	<517A28D7.3010707@intel.com>
	<CANN689F7c8UbxGEHyAOH+uwZxFf7VoQDmCM3Nv862s2b=21bQg@mail.gmail.com>
	<517A3FA0.8030702@intel.com>
Date: Fri, 26 Apr 2013 02:02:15 -0700
Message-ID: <CANN689FWig4wVomOzQpSLYAdwuWVjrUZa5KNEDH2pieKCa0ceA@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes for 3.9
From: Michel Lespinasse <walken@google.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 1:49 AM, Matt Fleming <matt.fleming@intel.com> wrote:
> On 26/04/13 08:43, Michel Lespinasse wrote:
>> Still seeing the crash.
>>
>> I went and compared the crash dump with the vmlinux disassembly; the
>> issue is a NULL pointer dereference in list_for_each_entry_safe().
>> list_empty() checks that the head node points to itself, but here the
>> head node has NULL. I think this may be due to gsmi_init() being
>> called before efivars_init(). Not sure what's the proper fix though.
>
> Ohh... I see what you mean. The bug is in variable_is_present() because
> it accesses __efivars directly, which a) isn't the struct efivars gsmi.c
> uses and b) hasn't been initialised. Something like this might work.

[... skipping patch ...]

Yes, this one fixes it. Thanks !

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
