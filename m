Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaJLXrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 19:47:35 -0400
Received: from roy.gaast.net ([80.101.33.21]:42653 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbaJLXrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 19:47:33 -0400
Message-ID: <543B12F7.7020703@gaast.net>
Date: Mon, 13 Oct 2014 00:47:03 +0100
From: Wilmer van der Gaast <wilmer@gaast.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: bhelgaas@google.com, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: Machine crashes right *after* ~successful resume
References: <54347520.3050109@gaast.net> <20141012143025.GA378@amd> <543AA2FE.20105@gaast.net> <20141012204032.GA11171@amd>
In-Reply-To: <20141012204032.GA11171@amd>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-10-14 21:40, Pavel Machek wrote:
> Bjorn, any ideas?
>
> Would it be feasible to revert 2e8b... to see if it fixes it on 3.17?
>
I've tried this, too many conflicts unfortunately.

Just noticed this message appear during failing resumes by the way:

[   54.203072] Clocksource tsc unstable (delta = -499956111 ns)
[   54.203151] Switched to clocksource hpet
[   54.203166] PM: resume of devices complete after 2142.341 msecs

Though not all the time. Feels like it's more another symptom of the 
same problem. In my original e-mail I already noted timing strangeness, 
with a 0.01s ping interval growing to 0.4s+.

Anyway, my previous bisect result appears to be wrong. :-( I've done 
another bisect on a narrow range around it, now 
928bea964827d7824b548c1f8e06eccbbc4d0d7d is considered guilty. I've 
rerun the test twice with that revision and the one before it 
(55ed83a615730c2578da155bc99b68f4417ffe20), and the result seems 
consistent now; 928bea gets me just two clean suspend+resumes, 55ed83 more.

I have tried to revert this change in a 3.17 tree but it didn't apply 
cleanly. One issue was a "Unreversed patch detected!" which looks to me 
like some of this work has been changed already. Even against a 3.12 
tree I get this issue.

Just to be sure, I've tried ignoring the unreversed patch warning and 
tweaked the patch in two more places to make it apply, but indeed that 
does not solve my problem.

A Google search for the revision number shows that there has been quite 
a discussion about it already. Maybe my machine has found another issue 
(though I suppose my machine's more guilty than the kernel! :-/).

>> I've tried unloading a bunch of modules (sound and NIC IIRC), same results.
>> I can try this again with an even more minimal set. If this improves the
>> situation, I'll post again.
>>
This is done: Still seeing the same issue. (And I'm using raw echo 
mem>/proc/... for all testing now.) Same for a "make defconfig" kernel.


Wilmer van der Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
