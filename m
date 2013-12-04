Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3LDXz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:55:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab3LDXzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:55:25 -0500
Date: Wed, 4 Dec 2013 15:02:39 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Adrien =?iso-8859-1?Q?Verg=E9?= <adrienverge@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Will Deacon <will.deacon@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 0/3] ARM Coresight: Enhance ETM tracing control
Message-ID: <20131204230239.GB9205@kroah.com>
References: <CANsc=4VRLWhaVA15HrBEeM+FJC0tS+b5KKopDb7bP8nxzR8=zA@mail.gmail.com>
 <20131204070442.GA31665@kroah.com>
 <CANsc=4UHEG5cmg9SD3r3rsuJnM9zqq2WiTQdUwrYFr_kkbsVvg@mail.gmail.com>
 <20131204170703.GA14859@kroah.com>
 <CANsc=4X7ThCvgz9bfu1ZZg9FCti5SMdbXL5tA584z-oZ_HEByg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANsc=4X7ThCvgz9bfu1ZZg9FCti5SMdbXL5tA584z-oZ_HEByg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 04:12:56PM -0500, Adrien Vergé wrote:
> 2013/12/4 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> > Your pid implementation is broken, see my other email about that :(
> 
> Thank you for your remarks on pid. I'll try to correct that.
> 
> > And again, what's wrong with the existing tracing functionalty that is
> > processor agnostic?  Why can't we just delete this driver today and use
> > the existing trace code?
> 
> As far as I know, the tracing functionality in
> /sys/kernel/debug/tracing does not take advantage of ETM. ETM is a
> dedicated hardware that greatly reduces tracing overhead. It only
> exists on ARM platforms.

How much overhead does the existing tracing code have on ARM?  Is ETM
still even needed?  Why not just use ETM for the core tracing code
instead?

> I understand using sysfs here is not the cleanest way. I patched my
> kernel to meet my needs (trace a specific process or address range),
> and I thought these small modifications could be useful -- until
> bigger work is done to remove ETM control from sysfs.
> 
> Do you think it's worth correcting my patch (for pid namespaces) and
> re-submitting it? Or should we wait for someone to port ETM tracing to
> debugfs?

What's wrong with the in-kernel tracing logic that you can't use that
instead of the ETM stuff?

And no, I don't think adding more functionality to this will be good to
do, ideally it could just be dropped...

thanks,

greg k-h
