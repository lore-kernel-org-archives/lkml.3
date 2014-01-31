Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbaAaTAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:00:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:41649 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbaAaTAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:00:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,759,1384329600"; 
   d="scan'208";a="447790597"
Message-ID: <52EBF2BF.2090807@linux.intel.com>
Date: Fri, 31 Jan 2014 11:00:15 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86, x32: Correct invalid use of user timespec in the kernel
References: <20140131025453.B594B660CA3@gitolite.kernel.org>	<20140131175009.GA27231@redhat.com>	<52EBE62E.70102@linux.intel.com> <CA+55aFwcgGPb=5cTnkKpP4vH2kqCCvxGteZT58efHhg3aJjcfQ@mail.gmail.com>
In-Reply-To: <CA+55aFwcgGPb=5cTnkKpP4vH2kqCCvxGteZT58efHhg3aJjcfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 10:45 AM, Linus Torvalds wrote:
> On Fri, Jan 31, 2014 at 10:06 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>> My feeling is that {get,put}_compat_timespec() should at the very least
>> have leading underscores to flag it as a low-level function, but better
>> suggestions would be appreciated.
> 
> Why not just remove it entirely, and change all users to
> compat_[get|set]_timespec (same for timeval etc, of course).
> 
> After all, compat_*_time*() does fall back cleanly for non-x32 cases.
> And sure, maybe that particular code is never *needed* for x32
> support, but the overhead is generally zero (since in most cases X32
> isn't even configured), or very low anyway. So the upside of having
> two subtly incompatible interfaces is very dubious, no?
> 

As they both seem to be out of line, I would think so.  More than half
of the use cases are in kernel/compat.c where we could use a
double-underscore inline version if we really care -- it would probably
be a net win in terms of performance.

There are only 25 call sites in the kernel of
'(get|put)_compat_time(val|spec)' and that includes the ones inside the
larger functions.

	-hpa

