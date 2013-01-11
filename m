Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3AKB0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 20:26:41 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:44580 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3AKB0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 20:26:40 -0500
Message-ID: <50EF6A2C.7070606@linux.vnet.ibm.com>
Date: Thu, 10 Jan 2013 17:26:04 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: paul.szabo@sydney.edu.au
CC: 695182@bugs.debian.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] Reproducible OOM with partial workaround
References: <201301110046.r0B0k6lR024284@como.maths.usyd.edu.au>
In-Reply-To: <201301110046.r0B0k6lR024284@como.maths.usyd.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011101-7408-0000-0000-00000BBF8A3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 04:46 PM, paul.szabo@sydney.edu.au wrote:
>> Your configuration has never worked.  This isn't a regression ...
>> ... does not mean that we expect it to work.
> 
> Do you mean that CONFIG_HIGHMEM64G is deprecated, should not be used;
> that all development is for 64-bit only?

My last 4GB laptop had a 1GB hole and needed HIGHMEM64G since it had RAM
at 0->5GB.  That worked just fine, btw.  The problem isn't with
HIGHMEM64G itself.

I'm not saying HIGHMEM64G is inherently bad, just that it gets gradually
worse and worse as you add more RAM.  I don't believe 64GB of RAM has
_ever_ been booted on a 32-bit kernel without either violating the ABI
(3GB/1GB split) or doing something that never got merged upstream (that
4GB/4GB split, or other fun stuff like page clustering).

> I find it puzzling that there seems to be a sharp cutoff at 32GB RAM,
> no problem under but OOM just over; whereas I would have expected
> lowmem starvation to be gradual, with OOM occuring much sooner with
> 64GB than with 34GB. Also, the kernel seems capable of reclaiming
> lowmem, so I wonder why does that fail just over the 32GB threshhold.
> (Obviously I have no idea what I am talking about.)

It _is_ puzzling.  It isn't immediately obvious to me why the slab that
you have isn't being reclaimed.  There might, indeed, be a fixable bug
there.  But, there are probably a bunch more bugs which will keep you
from having a nice, smoothly-running system, mostly those bugs have not
had much attention in the 10 years or so since 64-bit x86 became
commonplace.  Plus, even 10 years ago, when folks were working on this
actively, we _never_ got things running smoothly on 32GB of RAM.  Take a
look at this:

http://support.bull.com/ols/product/system/linux/redhat/help/kbf/g/inst/PrKB11417

You are effectively running the "SMP kernel" (hugemem is a completely
different beast).

I had a 32GB i386 system.  It was a really, really fun system to play
with, and its never-ending list of bugs helped keep me employed for
several years.  You don't want to unnecessarily inflict that pain on
yourself, really.

