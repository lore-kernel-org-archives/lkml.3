Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3DTXwO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 19:52:14 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59834 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947Ab3DTXwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 19:52:13 -0400
Date: Sat, 20 Apr 2013 16:52:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: irq 16: nobody cared
Message-ID: <20130420235206.GA3509@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130420185330.GA4654@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130420185330.GA4654@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042023-5806-0000-0000-000020CE94B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 20, 2013 at 08:53:30PM +0200, Borislav Petkov wrote:
> Hi Paul,
> 
> so I've been bisecting another issue and have been seeing the warning
> in the attached pic. Reverting c0f4dfd4f90f1667d234d21f15153ea09a2eaa66
> ("rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks") seems
> to fix the issue. The warning appears as the last thing on the screen
> before the machine goes down after being suspended to disk.
> 
> And IRQ 16 and azx_interrupt both belong to hda_intel.c
> 
> Any ideas?

Hmmm...  Does this problem occur only with CONFIG_RCU_FAST_NO_HZ=y,
or does it occur unconditionally?  (My guess is the former, but figured
I should check.)

							Thanx, Paul

