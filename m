Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab3CLGBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:01:19 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:55257 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3CLGBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:01:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130312054028.GA20037@mtj.dyndns.org>
References: <20130306191408.GN1227@htj.dyndns.org>
	<CALZhoSTPBNjhUP4R=vX0Ot7eAA8POTAy8K5Cd3KRe_y8PzjfFA@mail.gmail.com>
	<CALZhoSRJ+HV93tDJo-57M-SdXi8Z6qW_bRV9FzSfGWuz8j-t8Q@mail.gmail.com>
	<20130307154907.GB29601@htj.dyndns.org>
	<alpine.LFD.2.02.1303071705310.22263@ionos>
	<CALZhoSQBH3RxSoaVDCYoCyRVRndht-Rk0rh_w5Dbp6+5T_auSw@mail.gmail.com>
	<20130312051215.GU14556@mtj.dyndns.org>
	<CALZhoSTnCC4si12xQXy2Cid5S2vAwOneOnZ_o2XNjidoqA9bsg@mail.gmail.com>
	<20130312052426.GV14556@mtj.dyndns.org>
	<CALZhoSSFnfU1oVtUOXF_gA3QjToqT-wtdckbMC43pDXwXZwupg@mail.gmail.com>
	<20130312054028.GA20037@mtj.dyndns.org>
Date: Tue, 12 Mar 2013 14:01:16 +0800
Message-ID: <CALZhoSQNeaErA5TrovPRTtAwGqsoFwMYRx=rCwSTzUoytw533A@mail.gmail.com>
Subject: Re: workqueue panic in 3.4 kernel
From: Lei Wen <adrian.wenl@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        leiwen@marvell.com, wwang27@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 1:40 PM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Mar 12, 2013 at 01:34:56PM +0800, Lei Wen wrote:
>> > Memory areas aren't always zero on allocation.
>>
>> Shouldn't work structure be allocated with kzalloc?
>
> It's not required to. work_struct can also be on stack. It's "init"
> after all. Also, if you require clearing the memory before initing,
> you would be just shifting problem from INIT to memory clearing.
>

I see...
How about only check those workqueue structure not on stack?
For current onstack usage is rare, and should be easier to check with.

Thanks,
Lei
