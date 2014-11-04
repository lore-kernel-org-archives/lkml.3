Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaKDCDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:03:09 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:48493 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaKDCDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:03:05 -0500
Message-ID: <1415066556.24825.24.camel@debian>
Subject: Re: [PATCH 2/2] x86, mce, amd: extend mce-inject for support
 threshold interrupt event injection on AMD platform
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        tony.luck@intel.com, ak@linux.intel.com, gong.chen@linux.intel.com,
        linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 04 Nov 2014 10:02:36 +0800
In-Reply-To: <20141103180047.GG27384@pd.tnic>
References: <1414718648-7766-1-git-send-email-slaoub@gmail.com>
	 <1414718648-7766-3-git-send-email-slaoub@gmail.com>
	 <CAOjmkp9Aec9Ec-93YvT5S_mMaxrOoZSYCDbjyWaxGV_dac6qog@mail.gmail.com>
	 <5457C0B3.30007@amd.com> <20141103180047.GG27384@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 19:00 +0100, Borislav Petkov wrote:
> On Mon, Nov 03, 2014 at 11:51:47AM -0600, Aravind Gopalakrishnan wrote:
> > On 11/3/2014 11:05 AM, Aravind Gopalakrishnan wrote:
> > >
> > >There are three ways that have been used to report machine check event.
> > >And they are MCE, CMCI/Threshold Interrupt, and POLL. On the Intel
> > >platform, CMCI/Threshold Interrupt and POLL share the same event handler
> > >- machine_check_poll(). However, on the AMD platform, they have a
> > >separate event handler. amd_threshold_interrupt() is used for handling
> > >Threshold Interrupt event. And machine_check_poll() has been used for
> > >polling other events.
> > >
> > >This patch introduces a new flag MCJ_INTERRUPT that will be used to
> > >separate CMCI/Threshold Interrupt and POLL handler in mce-inject.
> > >
> > >Signed-off-by: Chen Yucong <slaoub@gmail.com <mailto:slaoub@gmail.com>>
> > >---
> > > arch/x86/include/asm/mce.h              |    5 +++--
> > > arch/x86/kernel/cpu/mcheck/mce-inject.c |   16 ++++++++++++++++
> > > arch/x86/kernel/cpu/mcheck/threshold.c  |    1 +
> > > 3 files changed, 20 insertions(+), 2 deletions(-)
> > >
> > 
> > 
> > We currently test decoding logic on AMD by performing mce injections using
> > edac/mce_amd_inj.c,
> > So instead of modifying mce-inject just for testing
> > amd_threshold_interrupt(),
> > Why not put it under mce_amd_inj? (It's AMD specific code anyway)
> 
> Right, I think this is supposed to be vendor-agnostic as it is calling
> mce_threshold_vector() directly.
> 
I'm not sure I understand your point. But mce_threshold_vector is shared
by AMD and Intel. 

> Btw, I wouldn't mind if someone would sit down and unify those injection
> methods and come up with a saner interface which can actually be used by
> humans, not those yucky files you feed mce-inject with...
> 
Anyway, I think it can be work well for testing EDAC/raddaemon/mcelog
decoding logic. So I suggest you try to use it, and you can add it to
your list of test tools.

thx!
cyc

