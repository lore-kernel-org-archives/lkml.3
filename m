Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab3AXWr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:47:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522Ab3AXWrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:47:22 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Zach Brown <zab@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Hillf Danton <dhillf@gmail.com>, Benjamin LaHaise <bcrl@kvack.org>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: next-20130117 - kernel BUG with aio
References: <3544.1358774694@turing-police.cc.vt.edu>
	<CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com>
	<2553.1358890098@turing-police.cc.vt.edu>
	<CAJd=RBCHRDzyjY_hOZCj6rHBXzb3f5wWxdqXYuLbQXLe2n4JeA@mail.gmail.com>
	<13450.1359048141@turing-police.cc.vt.edu>
	<20130124211850.GH26407@google.com>
	<20130124132759.c892fb4c.akpm@linux-foundation.org>
	<20130124213958.GJ26407@google.com>
	<20130124222537.GF14246@lenny.home.zabbo.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 24 Jan 2013 17:47:15 -0500
In-Reply-To: <20130124222537.GF14246@lenny.home.zabbo.net> (Zach Brown's
	message of "Thu, 24 Jan 2013 14:25:37 -0800")
Message-ID: <x494ni6jj0s.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown <zab@redhat.com> writes:

>> No, I didn't see that bug until after I'd fixed the other three, but as
>> far as I can tell everything's fixed with the patches I'm about to mail
>> out - my test VM has been running for the past two days without errors,
>> it's kill -9'ing a process that's got iocbs in flight to a loopback
>> device every two seconds.
>
> I'm really worried that this patch series hasn't seen significant enough
> testing to justify being queued.
>
> I'll be first in line for blame for not finding the time to finish my
> review of the series.
>
> What specific tests has this gone through?  The aio tests in xfstests /
> ltp?  (And as you discovered while chasing this bug, whatever platform
> you were running on doesn't seem slow enough to catch some paths.. run
> all the tests over loop?)
>
> Jeff, can you suggest a more modern testing regime for the aio core?
> It's been so long since I had to hammer on this stuff..

Modern?  No.  ;-) I usually use xfstests (all of them, not just the aio
group), the libaio test harness, and then hand it off to our performance
team to stress the code under benchmarking workloads.  Oh, and usually
targeted testing for the thing that I'm working on.

I'll put a couple of kernels together to hand off to our performance
team, though I don't know how much time they have at present.

Cheers,
Jeff
