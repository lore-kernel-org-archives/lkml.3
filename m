Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3GKKHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:07:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48397 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab3GKKHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:07:39 -0400
Date: Thu, 11 Jul 2013 12:07:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Hard lockups using 3.10.0
Message-ID: <20130711100721.GA28131@pd.tnic>
References: <8484013.LsABBJRIOx@devpool02>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8484013.LsABBJRIOx@devpool02>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 11:38:37AM +0200, Rolf Eike Beer wrote:
> Hi,
> 
> I'm running 3.10.0 (from openSUSE packages) on an "Intel(R) Core(TM) i7-2600 
> CPU @ 3.40GHz". I got a hard lockup on one of my CPUs twice, once with 
> backtrace (see attached image). Graphics is the builtin Intel, used with X 7.6 
> and KDE 4.10beta2 (basically current openSUSE 12.3+KDE).
> 
> I'm not aware that I had done anything special, just "normal" desktop and 
> development usage, but no heavy compile work at the moment the lockups 
> happened.

Hmm, I can see commit_creds() doing some rcu pointers assignment and rcu
calling into the scheduler which screams about a cpu runqueue of the
task we're about to reschedule not being locked. Let's add some more
people who should know better.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
