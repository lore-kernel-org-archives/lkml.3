Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab3EWOuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:50:13 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:54942 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589Ab3EWOuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:50:10 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwzedGVew7CCSqZ-Z=2ELt+A4L--mEQGjtALbMSB3LFoQ@mail.gmail.com>
References: <5195ED8B.7060002@meduna.org>
	<1369183168.6828.168.camel@gandalf.local.home>
	<519CBB30.3060200@redhat.com>
	<CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>
	<20130522134111.33a695c5@cuia.bos.redhat.com>
	<519D08B0.8050707@meduna.org>
	<1369246316.6828.176.camel@gandalf.local.home>
	<519D0CAB.7020800@meduna.org>
	<519D0FF8.5080200@redhat.com>
	<519D118B.6010306@zytor.com>
	<519D11BF.5000604@redhat.com>
	<519DCE2A.4010801@meduna.org>
	<CA+55aFwzedGVew7CCSqZ-Z=2ELt+A4L--mEQGjtALbMSB3LFoQ@mail.gmail.com>
Date: Thu, 23 May 2013 07:50:09 -0700
X-Google-Sender-Auth: pVW0DB-FTZU9VXVTylA4LmiPofc
Message-ID: <CA+55aFzZdgp0Z3J_6WBAKin-J5k1aLxjaGvLcXxQEuChpD=bXw@mail.gmail.com>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stanislav Meduna <stano@meduna.org>
Cc: Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 7:45 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Page faults that don't cause us to map a page (ie a spurious one, or
> one that just updates dirty/accessed bits) don't show up as even minor
> faults. Thing of the major/minor as "mapping activity" not a page
> fault count.

Actually, I take that back. We always update eithe rmin_flt or maj_flt. My bad.

Another question: I'm assuming this is all 32-bit, is it with PAE
enabled? That changes some of the TLB flushing, and we had one bug
related to that, maybe there are others..

            Linus
