Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964874AbbA1UtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:49:03 -0500
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:46510 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964828AbbA1Us5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:48:57 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2912:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:5007:6261:7514:7875:7903:10004:10400:10848:10967:11026:11232:11658:11914:12296:12438:12517:12519:12740:13069:13095:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trees29_78cef088c710b
X-Filterd-Recvd-Size: 1898
Date: Wed, 28 Jan 2015 09:53:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v4] trace: Use 64-bit timekeeping
Message-ID: <20150128095349.6a3537a2@gandalf.local.home>
In-Reply-To: <20150128141611.GA2701@tinar>
References: <20150128141611.GA2701@tinar>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015 19:46:11 +0530
Tina Ruchandani <ruchandani.tina@gmail.com> wrote:

> The ring_buffer_producer uses 'struct timeval' to measure
> its start and end times. 'struct timeval' on 32-bit systems
> will have its tv_sec value overflow in year 2038 and beyond.
> This patch replaces struct timeval with 'ktime_t' which uses
> 64-bit representation for nanoseconds.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> ---
> Changes in v4:
> 	- Fix typo in commit message.
> 	- Avoid typecast to 'long long' by defining RUN_TIME as '10ULL'
> 	  instead of '10'.

Although I have not tested this, this patch looks fine to me. Is this
going to go through some cleanup tree or should I just pull it?

-- Steve


> Changes in v3:
> 	- Use a more efficient way to compute condition for exiting loop.
> 	- Fix variable naming - all caps is only for macros.
> Changes in v2:
> 	- Use ktime_t instead of timespec64 for efficiency reasons.
