Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3CLFe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:34:59 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35772 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab3CLFe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:34:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130312052426.GV14556@mtj.dyndns.org>
References: <20130305163228.GA12795@htj.dyndns.org>
	<CALZhoSRyjRYVcKpq9cECHWgKkci6V+O_zn2CkiwqnFo57tZDfQ@mail.gmail.com>
	<20130306191408.GN1227@htj.dyndns.org>
	<CALZhoSTPBNjhUP4R=vX0Ot7eAA8POTAy8K5Cd3KRe_y8PzjfFA@mail.gmail.com>
	<CALZhoSRJ+HV93tDJo-57M-SdXi8Z6qW_bRV9FzSfGWuz8j-t8Q@mail.gmail.com>
	<20130307154907.GB29601@htj.dyndns.org>
	<alpine.LFD.2.02.1303071705310.22263@ionos>
	<CALZhoSQBH3RxSoaVDCYoCyRVRndht-Rk0rh_w5Dbp6+5T_auSw@mail.gmail.com>
	<20130312051215.GU14556@mtj.dyndns.org>
	<CALZhoSTnCC4si12xQXy2Cid5S2vAwOneOnZ_o2XNjidoqA9bsg@mail.gmail.com>
	<20130312052426.GV14556@mtj.dyndns.org>
Date: Tue, 12 Mar 2013 13:34:56 +0800
Message-ID: <CALZhoSSFnfU1oVtUOXF_gA3QjToqT-wtdckbMC43pDXwXZwupg@mail.gmail.com>
Subject: Re: workqueue panic in 3.4 kernel
From: Lei Wen <adrian.wenl@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        leiwen@marvell.com, wwang27@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 1:24 PM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Mar 12, 2013 at 01:18:01PM +0800, Lei Wen wrote:
>> > You're initializing random piece of memory which may contain any
>> > garbage and triggering BUG if some bit is set on it. No, you can't do
>> > that. debugobj is the right tool for debugging object lifetime issues
>> > and is already supported.
>>
>> The debugobj is not helping on this issue, I have enabled both
>> CONFIG_DEBUG_OBJECTS_WORK and CONFIG_DEBUG_OBJECTS.
>> But find they didn't report any issue at all.
>
> It should. No idea why it didn't. Would be interesting to find out
> why.

No idea about it also...

>
>> And I am not init random memory, original issue is call init multi-times
>> for one structure and that piece of memory already been allocated.
>> And __INIT_WORK shouldn't call over random memory, right?
>
> Memory areas aren't always zero on allocation.


Shouldn't work structure be allocated with kzalloc?

Thanks,
Lei
