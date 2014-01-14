Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaANQWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:22:10 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:60089 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaANQWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:22:07 -0500
Date: Tue, 14 Jan 2014 17:22:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Aravind.Gopalakrishnan@amd.com,
        tglx@linutronix.de, bp@suse.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/microcode] x86, microcode: Move to a proper location
Message-ID: <20140114162203.GB31037@gmail.com>
References: <tip-bad5fa631fca5466401cd4a48e30cc1f1cb6101e@git.kernel.org>
 <52D56174.9010608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D56174.9010608@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 01/14/2014 05:58 AM, tip-bot for Borislav Petkov wrote:
> > Commit-ID:  bad5fa631fca5466401cd4a48e30cc1f1cb6101e
> > Gitweb:     http://git.kernel.org/tip/bad5fa631fca5466401cd4a48e30cc1f1cb6101e
> > Author:     Borislav Petkov <bp@suse.de>
> > AuthorDate: Sun, 1 Dec 2013 18:09:58 +0100
> > Committer:  Borislav Petkov <bp@suse.de>
> > CommitDate: Mon, 13 Jan 2014 20:00:12 +0100
> > 
> > x86, microcode: Move to a proper location
> > 
> > We've grown a bunch of microcode loader files all prefixed with
> > "microcode_". They should be under cpu/ because this is strictly
> > CPU-related functionality so do that and drop the prefix since they're
> > in their own directory now which gives that prefix. :)
> > 
> > While at it, drop MICROCODE_INTEL_LIB config item and stash the
> > functionality under CONFIG_MICROCODE_INTEL as it was its only user.
> > 
> 
> Quite frankly I would be much happier if we didn't stash so much 
> under arch/x86/kernel/cpu ... quite frankly it feels like almost 
> *anything* could go under there.  The microcode code, for example, 
> could go under its own subtree.
> 
> Both kernel and kernel/cpu really could use a house cleaning and 
> actually separate things out into better categories and avoid 
> needlessly deep pathnames.

Absolutely. I think moving arch/x86/kernel/cpu/ to arch/x86/cpu/ would 
be a first good step. It's all kernel code, there's other 
subdirectories there that are kernel code ('pci/', 'platform/', etc.), 
so there's little point in continuing the historic accident of a 
'kernel/' subdirectory.

Once that is done we can move certain things outside as well - for 
example arch/x86/cpu/perf/ could probably move to arch/x86/events/, 
because that code is not about CPU events anymore either.

Thanks,

	Ingo
