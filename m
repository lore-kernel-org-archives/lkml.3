Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab3CLGNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:13:08 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:42769 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab3CLGNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:13:07 -0400
Date: Mon, 11 Mar 2013 23:13:03 -0700
From: Tejun Heo <tj@kernel.org>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        leiwen@marvell.com, wwang27@marvell.com
Subject: Re: workqueue panic in 3.4 kernel
Message-ID: <20130312061303.GB20037@mtj.dyndns.org>
References: <CALZhoSRJ+HV93tDJo-57M-SdXi8Z6qW_bRV9FzSfGWuz8j-t8Q@mail.gmail.com>
 <20130307154907.GB29601@htj.dyndns.org>
 <alpine.LFD.2.02.1303071705310.22263@ionos>
 <CALZhoSQBH3RxSoaVDCYoCyRVRndht-Rk0rh_w5Dbp6+5T_auSw@mail.gmail.com>
 <20130312051215.GU14556@mtj.dyndns.org>
 <CALZhoSTnCC4si12xQXy2Cid5S2vAwOneOnZ_o2XNjidoqA9bsg@mail.gmail.com>
 <20130312052426.GV14556@mtj.dyndns.org>
 <CALZhoSSFnfU1oVtUOXF_gA3QjToqT-wtdckbMC43pDXwXZwupg@mail.gmail.com>
 <20130312054028.GA20037@mtj.dyndns.org>
 <CALZhoSQNeaErA5TrovPRTtAwGqsoFwMYRx=rCwSTzUoytw533A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZhoSQNeaErA5TrovPRTtAwGqsoFwMYRx=rCwSTzUoytw533A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 02:01:16PM +0800, Lei Wen wrote:
> I see...
> How about only check those workqueue structure not on stack?
> For current onstack usage is rare, and should be easier to check with.

No, kzalloc is not required. The memory area can come from any source.
If you're interested in improving the debug situation, please stop
trying to do something impossible (you can't track lifetime of random
memory area without extra bookkeeping) try to find out why debugobj
didn't detect it (did you even enable it? either via
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT or "debug_objects" boot param).

-- 
tejun
