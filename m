Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab3AVJk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:40:56 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:42216 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3AVJky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:40:54 -0500
MIME-Version: 1.0
In-Reply-To: <1358846546.12502.57.camel@smile>
References: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==FoW5Sh5KFt9iO+_04dEbwsQHJX3rsTWNqFiZqTbPn6A@mail.gmail.com>
	<1358846546.12502.57.camel@smile>
Date: Tue, 22 Jan 2013 15:10:53 +0530
Message-ID: <CAKohpo=m-s4+q+4v2v+8nzC32FRzJAb58no2hZLV_5QqTj4wig@mail.gmail.com>
Subject: Re: [PATCH 2/2] dw_dmac: return proper residue value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 January 2013 14:52, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Tue, 2013-01-22 at 13:41 +0530, Viresh Kumar wrote:
>> > +       spin_lock_irqsave(&dwc->lock, flags);
>> > +       if (list_empty(&dwc->active_list)) {
>>
>> can this every happen?
>
> In the same way as in dwc_scan_descriptors().
> For example when transfer is done.

My point was, because scan_descriptor() is just called, if the transfer
is over by now, we must have returned back, else we reach this place
and so this may never be true.

>> Over that, cyclic case can be handled before taking any locks.
>
> Does the user is responsible to follow specific workflow for cyclic API?

not sure.

>> Just before above line got executed, we called dwc_scan_descriptors(), which
>> also scans through the llis to see where we are.. What about updating
>> first->residue
>> there, so that we don't traverse it twice?
>
> The dwc_scan_descriptors traverses the chain and returns immediately if
> it found a match. But to calculate residue we have to traverse from that
> point to the end of the chain along with current DMA register check.

Hey, you can start subtracting individual lengths of descriptors from
total length
in scan descriptors() and that should give you what you want.
