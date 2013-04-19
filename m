Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030844Ab3DSPm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:42:56 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34500 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030656Ab3DSPmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:42:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130419140938.GT14496@n2100.arm.linux.org.uk>
References: <1365651547-11583-1-git-send-email-zhangwm@marvell.com>
	<CAN1soZxCX1oUg69MTy0ZAL2vH8SOywDBaZHJ7wgnwgasxPAPdQ@mail.gmail.com>
	<20130419140938.GT14496@n2100.arm.linux.org.uk>
Date: Fri, 19 Apr 2013 23:42:53 +0800
Message-ID: <CAN1soZwsC6yjH3nG7zUvRf9x9SLuEC4b9DtqsTGWQhacu78EbQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM: mmp: add SMP support for pxa988
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Neil Zhang <zhangwm@marvell.com>, Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chao Xie <chao.xie@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 10:09 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Apr 13, 2013 at 09:08:12PM +0800, Haojian Zhuang wrote:
>> On Thu, Apr 11, 2013 at 11:39 AM, Neil Zhang <zhangwm@marvell.com> wrote:
>> > +       /*
>> > +        * Synchronise with the boot thread.
>> > +        */
>> > +       spin_lock(&boot_lock);
>> > +       spin_unlock(&boot_lock);
>> Lock & unlock without protecting anything. If so, you can remove this.
>
> ... which means you don't understand what is going on in this code,
> and probably didn't read the comment above this fragment.  The above
> is to synchronise with the code below - again, read the comment at
> the spin unlock in this function, remembering that the above code
> and the code below runs concurrently on two different CPUs:
>
Yes, I misunderstood it. Thanks for your correction.

Regards
Haojian
