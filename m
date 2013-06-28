Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab3F1A5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 20:57:09 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53353 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab3F1A5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 20:57:07 -0400
Date: Fri, 28 Jun 2013 08:56:42 +0800
From: Wang YanQing <udknight@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        bp@suse.de, fenghua.yu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix override new_cpu_data.x86 with 486
Message-ID: <20130628005642.GA2232@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Borislav Petkov <bp@alien8.de>, hpa@zytor.com, tglx@linutronix.de,
	mingo@redhat.com, x86@kernel.org, bp@suse.de, fenghua.yu@intel.com,
	linux-kernel@vger.kernel.org
References: <20130626162640.GA19913@udknight>
 <20130627105435.GA21297@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627105435.GA21297@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 12:54:35PM +0200, Borislav Petkov wrote:
> On Thu, Jun 27, 2013 at 12:26:40AM +0800, Wang YanQing wrote:
> > 
> > We should set X86 to 486 before use cpuid
> > to detect the cpu type, if we set X86 to 486
> > after cpuid, then we will get 486 for ever.
> 
> So not "for ever" but until cpu_detect runs.
> 
> > 
> > Yes, we will correct this in early_cpu_init,
> > but it is still a wrong behavior, right? So
> > just fix it.
> 
> Right, so this patch is correct and it fixes the small window where we
> run with family == 4 before cpu_detect but the commit message needs a
> bit massaging before it gets applied.

I think it fixes the window where we run with family > 4 before cpu_detect :)

> 
> > 
> > I also find maybe we can delete the new_cpu_data,
> > because we will over write all the information
> > in early_cpu_init, and before early_cpu_init,
> > there is no user of new_cpu_data, but this is
> > another patch in the future.
> 
> You can drop that part.

I can't catch the exactly meaning:

We can drop the new_cpu_data or 
I need to drop this part commit
message.


Thanks.
