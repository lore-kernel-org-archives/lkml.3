Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3EVSMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:12:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab3EVSMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:12:00 -0400
X-Authority-Analysis: v=2.0 cv=IZAFqBWa c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=rKI68ldaRsEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=54K5z7jWVYMA:10 a=4QIxAgZS9Tt0D_6QZzoA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369246316.6828.176.camel@gandalf.local.home>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
From: Steven Rostedt <rostedt@goodmis.org>
To: Stanislav Meduna <stano@meduna.org>
Cc: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Date: Wed, 22 May 2013 14:11:56 -0400
In-Reply-To: <519D08B0.8050707@meduna.org>
References: <5195ED8B.7060002@meduna.org>
	 <1369183168.6828.168.camel@gandalf.local.home>
	 <519CBB30.3060200@redhat.com>
	 <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>
	 <20130522134111.33a695c5@cuia.bos.redhat.com> <519D08B0.8050707@meduna.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-22 at 20:04 +0200, Stanislav Meduna wrote:
> On 22.05.2013 19:41, Rik van Riel wrote:
> 
> >> I think you should also remove the
> >>
> >>         if (flags & FAULT_FLAG_WRITE)
> 
> Done
> 
> >>> Can you test the attached patch?
> 
> Nope. Fails with the same symptoms, min_flt skyrockets,
> the throttler activates and after 2 seconds all is well
> again.
> 
> This is on Geode LX, I don't have the Celeron M at the hand now.
> 

Did you apply both patches? Without the first one, this one is
meaningless.

-- Steve


