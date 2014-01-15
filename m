Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaAOSiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:38:18 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:48856 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaAOSiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:38:12 -0500
Date: Wed, 15 Jan 2014 19:38:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, aravind.gopalakrishnan@amd.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, cpu, amd: Add workaround for family 16h,
 erratum 793
Message-ID: <20140115183807.GA23486@gmail.com>
References: <20140114230711.GS29865@pd.tnic>
 <tip-3b56496865f9f7d9bcb2f93b44c63f274f08e3b6@git.kernel.org>
 <52D5DC51.9010606@zytor.com>
 <20140115062817.GA11869@gmail.com>
 <20140115133619.GA32051@pd.tnic>
 <52D69291.8080003@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D69291.8080003@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> On 01/15/2014 05:36 AM, Borislav Petkov wrote:
> >>
> >> msr_read() would essentially map to rdmsr_safe(). Each method has a
> >> return value that can be checked for failure.
> > 
> > I'm not sure we want to use the _safe() variants by default as it 
> > would generate the exception tables even in cases where they're 
> > clearly not needed.

I don't think those new methods should be inline functions - thus 
there will be only one exception entry for each.

> It would be particularly silly if what you end up with is in effect 
> to wrap msr_read/write() in a BUG_ON(), which is the effect of the 
> current (trapping) form.  There is something to be said for hard 
> errors.

Right, the fact that most of our MSR accesses today are 
crash-on-failure, which happens to trigger crashes on a regular 
schedule, where most of the crashes are 'harmless' situation except 
that they crash the systems for good.

So I think defaulting to soft failures is the right approach.

Thanks,

	Ingo
