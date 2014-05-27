Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaE0BGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:06:12 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:61734 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaE0BGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:06:08 -0400
Date: Mon, 26 May 2014 18:06:05 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] get_maintainer script cleanups
Message-ID: <20140526180605.1507c79a@nehalam.linuxnetplumber.net>
In-Reply-To: <1401152449.519.41.camel@joe-AO725>
References: <20140526203309.782169359@networkplumber.org>
	<1401152449.519.41.camel@joe-AO725>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2014 18:00:49 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-05-26 at 13:33 -0700, Stephen Hemminger wrote:
> > Some simple perl hacking changes.
> 
> I don't really care for these.
> 
> Why do you think these are better?
> 
> I think the first one breaks the code too.
> 
> 

$ perlcritic scripts/get_maintainer.pl 
Use IO::Interactive::is_interactive() instead of -t at line 237, column 5.  See page 218 of PBP.  (Severity: 5)
Two-argument "open" used at line 429, column 2.  See page 207 of PBP.  (Severity: 5)
Expression form of "eval" at line 1410, column 17.  See page 161 of PBP.  (Severity: 5)
Expression form of "eval" at line 1412, column 17.  See page 161 of PBP.  (Severity: 5)

If you read Perl Best Practices you will see why these are issues.
The first is because the test for STDIN and ARGV is not sufficient to check for
interactive usage.

The next is because using quoted two arg open breaks if there is a space in name etc.

Lastly eval of a string leads to runtime errors versus compile time.

Yes, for a trivial program like this it really doesn't matter.
But this program is likely to grow and be copied by other developers
and I would like it to use current best practices. The same applies to
all the other parts of the kernel.

I tested each step, and they all work for me™ 
