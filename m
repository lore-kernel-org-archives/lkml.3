Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3LJSlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:41:47 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:61785 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3LJSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:41:45 -0500
MIME-Version: 1.0
In-Reply-To: <52A6C1D8.7020900@intel.com>
References: <CACwUX0PEYGsNMDvy85EsrApWzNU3iTyY-1KHMaj1ay0xxKX6RQ@mail.gmail.com>
	<CACwUX0PGGM99-2H41S0eqOVLsh-7+Dan+gcy9deK1movx_wWPQ@mail.gmail.com>
	<CAKocOOOT2J_+hmEsAnAJVWV7TOqgApd3Lih+3WaRob4e8Nex4Q@mail.gmail.com>
	<52A6C1D8.7020900@intel.com>
Date: Tue, 10 Dec 2013 11:41:44 -0700
Message-ID: <CACwUX0MdiFLCf-QxZbVxk3+iZTe80XnZbrCB88JCDs8Vr3=-wg@mail.gmail.com>
Subject: Re: UBIFS recovery taking too long
From: David Mosberger-Tang <dmosberger@gmail.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Shuah Khan <shuahkhan@gmail.com>, dedekind1@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian,

On Tue, Dec 10, 2013 at 12:25 AM, Adrian Hunter <adrian.hunter@intel.com> wrote:

> Slowness is probably caused by trying to make free space.  Was the file
> system very full?  A smaller journal might help.

That's possible.  We have not been able to reproduce the issue in
house but a customer had it happen on several devices in a row (3 or 4
of them, I believe).  I don't think we are very sensitive to how long
it takes we just need to know an upper bound on the recovery time.

> Probably the only way to determine worst-case recovery time is to test it.
> Worst case conditions are likely to be a full journal and a nearly full file
> system.

I have not found a lot of UBIFS stresstest tools or even tools to
display what state UBIFS is in.  Can you point me to something?  I
assume lots of small writes would fill up the journal?  We'd be very
happy to test this more but as things stands, it's very hard to tell
how full the filesystem even is (due to compression) and I'm not sure
how to check on the state of the journal.

> Ideally you want to capture a file system image that exhibits the slow
> behaviour, then you can enable debug messages and see what it is doing.

OK, the two devices we've seen this initially have been restored so we
can't find out from those.
However, the customer affected by this issue may have another device
or two they haven't sent
back yet.  We might be able to snapshot the root filesystem on one of those.

  --david

>>>
>>> Thanks,
>>>
>>>   --david
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>
