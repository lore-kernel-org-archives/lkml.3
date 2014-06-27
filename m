Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaF0KSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 06:18:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55132 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbaF0KSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 06:18:39 -0400
Date: Fri, 27 Jun 2014 12:18:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: lkml <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: __schedule #DF splat
Message-ID: <20140627101831.GB23153@pd.tnic>
References: <20140625153227.GA13845@pd.tnic>
 <20140625202650.GC13845@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140625202650.GC13845@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:26:50PM +0200, Borislav Petkov wrote:
> On Wed, Jun 25, 2014 at 05:32:28PM +0200, Borislav Petkov wrote:
> > Hi guys,
> > 
> > so I'm looking at this splat below when booting current linus+tip/master
> > in a kvm guest. Initially I thought this is something related to the
> > PARAVIRT gunk but it happens with and without it.
> 
> Ok, here's a cleaner splat. I went and rebuilt qemu to latest master
> from today to rule out some breakage there but it still fires.

Ok, another observation: I was using qemu from sources from the other day:

v2.0.0-1806-g2b5b7ae917e8

Switching back to the installed one:

$ qemu-system-x86_64 --version
QEMU emulator version 1.7.1 (Debian 1.7.0+dfsg-6), Copyright (c) 2003-2008 Fabrice Bellard

fixes the issue.

Joerg says I should bisect but I'm busy with other stuff. If people are
interested in chasing this further, I could free up some time to do
so...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
