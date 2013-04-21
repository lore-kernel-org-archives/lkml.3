Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3DUQaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 12:30:23 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40903 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3DUQaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 12:30:22 -0400
Date: Sun, 21 Apr 2013 09:30:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        tiwai@suse.de
Subject: Re: irq 16: nobody cared
Message-ID: <20130421163002.GB3509@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130420185330.GA4654@pd.tnic>
 <20130420235206.GA3509@linux.vnet.ibm.com>
 <20130421103403.GA4594@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421103403.GA4594@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042116-2876-0000-0000-000007BB2FF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 12:34:03PM +0200, Borislav Petkov wrote:
> On Sat, Apr 20, 2013 at 04:52:07PM -0700, Paul E. McKenney wrote:
> > Hmmm... Does this problem occur only with CONFIG_RCU_FAST_NO_HZ=y, or
> > does it occur unconditionally? (My guess is the former, but figured I
> > should check.)
> 
> Your guess is correct, sir.
> 
> >From quickly grepping in /boot/, I have CONFIG_RCU_FAST_NO_HZ=y in all
> my 3.9 configs. So I went and turned it off and the issue doesn't appear
> anymore.

Thank you for the info!  Now to figure out what the heck is causing this.

I am also guessing that your system does have hardware that could do an
irq 16.  Of course, if removing or disabing this hardware is an option,
it would be interesting to see what happens.  Especially given that at the
very bottom of the .jpg, there is a chopped-off line that appears to read
"Disabling IRQ #16".  Which of course leads me to wonder whether we hit
a race between the last interrupt arriving and the device being disabled.

Hmmm...  Do you have either CONFIG_PM_SLEEP, SUPPORT_VGA_SWITCHEROO,
or CONFIG_PM_RUNTIME set for these runs?

Adding Takashi Iwai on CC in case he has any insight.

							Thanx, Paul

