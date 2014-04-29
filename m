Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaD2Wx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:53:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaD2Wxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:53:55 -0400
Date: Tue, 29 Apr 2014 15:53:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, sandeen@redhat.com,
        jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz,
        fengguang.wu@intel.com, mpatlasov@parallels.com
Subject: Re: [PATCH] mm,writeback: fix divide by zero in pos_ratio_polynom
Message-Id: <20140429155353.8fe070101d3b4faa0c825d99@linux-foundation.org>
In-Reply-To: <53602C2B.50604@redhat.com>
References: <20140429151910.53f740ef@annuminas.surriel.com>
	<20140429153936.49a2710c0c2bba4d233032f2@linux-foundation.org>
	<53602C2B.50604@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 18:48:11 -0400 Rik van Riel <riel@redhat.com> wrote:

> On 04/29/2014 06:39 PM, Andrew Morton wrote:
> > On Tue, 29 Apr 2014 15:19:10 -0400 Rik van Riel <riel@redhat.com> wrote:
> > 
> >> It is possible for "limit - setpoint + 1" to equal zero, leading to a
> >> divide by zero error. Blindly adding 1 to "limit - setpoint" is not
> >> working, so we need to actually test the divisor before calling div64.
> >>
> >> ...
> >>
> >> --- a/mm/page-writeback.c
> >> +++ b/mm/page-writeback.c
> >> @@ -597,11 +597,16 @@ static inline long long pos_ratio_polynom(unsigned long setpoint,
> >>  					  unsigned long dirty,
> >>  					  unsigned long limit)
> >>  {
> >> +	unsigned int divisor;
> > 
> > I'm thinking this would be better as a ulong so I don't have to worry
> > my pretty head over truncation things?
> 
> I looked at div_*64, and the second argument is a 32 bit
> variable. I guess a long would be ok, since if we are
> dividing by more than 4 billion we don't really care :)
> 
> static inline s64 div_s64(s64 dividend, s32 divisor)

ah, good point.  Switching to ulong is perhaps a bit misleading then.

