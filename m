Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3LaKqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 05:46:15 -0500
Received: from 1wt.eu ([62.212.114.60]:54703 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab3LaKqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 05:46:14 -0500
Date: Tue, 31 Dec 2013 11:45:11 +0100
From: Willy Tarreau <w@1wt.eu>
To: Krzysztof Ha??asa <khalasa@piap.pl>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: v3.13-rc6+ regression (ARM board)
Message-ID: <20131231104511.GA9688@1wt.eu>
References: <m3mwjhux0e.fsf@t19.piap.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3mwjhux0e.fsf@t19.piap.pl>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 11:37:21AM +0100, Krzysztof Ha??asa wrote:
> Hi,
> 
> There seems to be a regression in v3.13-rc6+ (up to current tip =
> 71ce176ee6ed1735b9a1160a5704a915d13849b1).
> 
> Board is Gateworks Cambria, CPU Intel IXP435 ARM big endian, gcc 4.7.3.
> The board boots correctly and works (shell mostly, and SSHD) for about
> 50 seconds. After 52-54 seconds, it frozes dead without any console
> (UART) output.
> 
> Bisecting shows 5e30025a319910695f5010dc0fb53a23299da14d as the first
> bad commit. Interestingly it's a merge:
> 
>    Merge branch 'core-locking-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> 
>     Pull core locking changes from Ingo Molnar:
>      "The biggest changes:
> 
>        - add lockdep support for seqcount/seqlocks structures, this
>          unearthed both bugs and required extra annotation.
> 
>        - move the various kernel locking primitives to the new
>          kernel/locking/ directory"
> 
> Both parents of this merge consistently show no such problem. The merge
> is basically automatic, I don't see any suspect there.
> 
> Any ideas?

No, but FWIW it works fine here on an armada370 (armv7). That doesn't
mean there's no bug, just that I'm not hitting it :-)

Willy

