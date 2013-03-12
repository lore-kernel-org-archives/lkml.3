Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab3CLGlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:41:13 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63617 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3CLGlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:41:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130312061303.GB20037@mtj.dyndns.org>
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
	<20130312061303.GB20037@mtj.dyndns.org>
Date: Tue, 12 Mar 2013 14:41:10 +0800
Message-ID: <CALZhoSST8DWKhG9FBJp_Z+WVMLVsiS84zebsNSsnLaKw0f=ZyA@mail.gmail.com>
Subject: Re: workqueue panic in 3.4 kernel
From: Lei Wen <adrian.wenl@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        leiwen@marvell.com, wwang27@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 2:13 PM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Mar 12, 2013 at 02:01:16PM +0800, Lei Wen wrote:
>> I see...
>> How about only check those workqueue structure not on stack?
>> For current onstack usage is rare, and should be easier to check with.
>
> No, kzalloc is not required. The memory area can come from any source.
> If you're interested in improving the debug situation, please stop
> trying to do something impossible (you can't track lifetime of random
> memory area without extra bookkeeping) try to find out why debugobj
> didn't detect it (did you even enable it? either via
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT or "debug_objects" boot param).
>


I see...
Thanks for the detailed explanation! :)

Thanks,
Lei
