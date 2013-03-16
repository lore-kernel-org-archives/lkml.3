Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab3CPN4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 09:56:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38666 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3CPN42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 09:56:28 -0400
Date: Sat, 16 Mar 2013 16:56:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 09/50] staging: omap-thermal: make a omap_bandgap_power
 with only one exit point
Message-ID: <20130316135618.GI9189@mwanda>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
 <1363352438-15935-10-git-send-email-eduardo.valentin@ti.com>
 <20130315212241.GL9138@mwanda>
 <514467EF.4010604@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514467EF.4010604@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 08:39:11AM -0400, Eduardo Valentin wrote:
> Hey Dan,
> 
> On 15-03-2013 17:22, Dan Carpenter wrote:
> >On Fri, Mar 15, 2013 at 08:59:57AM -0400, Eduardo Valentin wrote:
> >>Change the way the omap_bandgap_power is written so that it has only
> >>one exit entry (Documentation/CodingStyle).
> >>
> >
> >It's only if there is an unlock or something that you should do
> >this.  Otherwise the pointless bunny hop is misleading and annoying.
> 
> Well, if that is the case the Chapter 7 needs to be rewritten, don't
> you think? The way it is stated, it is clear that it is a design
> decision to use it for keeping only one exit point (quoting):
> 
> "Albeit deprecated by some people, the equivalent of the goto statement is
> used frequently by compilers in form of the unconditional jump instruction.
> 
> The goto statement comes in handy when a function exits from multiple
> locations and some common work such as cleanup has to be done.
> 
> The rationale is:
> 
> - unconditional statements are easier to understand and follow
> - nesting is reduced
> - errors by not updating individual exit points when making
>     modifications are prevented
> - saves the compiler work to optimize redundant code away ;)"
> 
> I believe this patch falls into at least three of the above rationale.

There isn't any cleanup work done.  That's what I was explaining
about.  When I see a goto I expect cleanup work to be done, but in
this case it was misleading.

Where you would do the one exit point is when there is cleanup:

	ret = function_one();
	if (ret)
		goto unlock;

	ret = function_two();
	if (ret)
		goto unlock;


That's better than:
	ret = function_one();
	if (ret) {
		mutex_unlock();
		return ret;
	}

	ret = function_two();
	if (ret) {
		mutex_unlock();
		return ret;
	}

On the one hand, I think the documentation should be updated because
obviously people get confused by it.  But on the other hand, to me
the documentation is already pretty clear.  There is no style
guideline that says every function should only have a single return.
That would be silly.

regards,
dan carpenter

