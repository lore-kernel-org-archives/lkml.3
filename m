Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3JDT3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:29:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57757 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab3JDT3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:29:52 -0400
Message-ID: <524F170A.2010806@ti.com>
Date: Fri, 4 Oct 2013 15:29:14 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-msm@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: Use of drivers/platform and matching include?
References: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org> <CAOesGMjJ6Uj0uGFJqtnWQyDW+tr6eLVWoHZ+B7uFna+L8N6E8Q@mail.gmail.com> <20131004114128.GL12758@n2100.arm.linux.org.uk> <20131004132209.GB23923@kroah.com> <CAOesGMjxwmr0Vo0Puc-nZntgXLy6D1PTohz=C+fFukP_Eu1iQg@mail.gmail.com>
In-Reply-To: <CAOesGMjxwmr0Vo0Puc-nZntgXLy6D1PTohz=C+fFukP_Eu1iQg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 October 2013 12:48 PM, Olof Johansson wrote:
> On Fri, Oct 4, 2013 at 6:22 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Fri, Oct 04, 2013 at 12:41:28PM +0100, Russell King - ARM Linux wrote:
>>>
>>> So, no, there will be no new drivers under arch/arm.  They must be in the
>>> drivers subtree somewhere.
>>
>> I have no objection with this, and encourage it.
> 
> Ok, so these are some of the requirements as far as I see it:
> 
> * No per-vendor driver dumping ground under drivers/* (i.e. no
> drivers/platform/<soc vendor>/)
> * No weirdly constructed single-driver directories directly under
> drivers/* (we already have a few and should look at moving those)
> because nothing else fits
> * We need some sort of convention on dependencies. Several of these
> are more libraries than drivers, i.e. we'll have cross-calls for
> things like queue management, resource allocation, etc. So having a
> single location to hold most of these makes sense instead of
> everything cross-depending on everything else.
> 
> Based on the above, how about we create something like
> drivers/resourcemgr to hold these?   I think at least parts of the
> mvebu-mbus driver that ended up under drivers/bus might be a fit to
> move there. The APM queue allocator would likely be a fit, and maybe
> some of the qualcomm stuff. Kumar, what are your thoughts on that?

Slightly different question but relevant to th thread w.r.t the Queue
allocator/manager. We are also interested for TI Keystone SOCs.

Currently we have generic drivers/hwqueue/ with core hwqueue
layer implementing the standard hardware queue descriptor push/pop
and notification mechanisms and then Keystone specific
driver using those core functionalities. I read most of the
networking SOCs has some sort of hwqueues but not sure about
the its implementations. So just thought of bringing
it into the thread discussion to see if hwqueue core layer is
of any interest to other SOCs.

Regards,
Santosh



