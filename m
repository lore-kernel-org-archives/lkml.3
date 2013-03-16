Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab3CPDcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 23:32:47 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36891 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab3CPDcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 23:32:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130315181449.GX4977@n2100.arm.linux.org.uk>
References: <CAM16m2=6S11d+eSSwQJ2f=nO6dM4K-dGKf3TR-z0nyBUyw=YxQ@mail.gmail.com>
	<20130315181449.GX4977@n2100.arm.linux.org.uk>
Date: Sat, 16 Mar 2013 11:32:43 +0800
Message-ID: <CAM16m2n_Of0MJNtUsrL0MS2cXBZUHg9RzjSHcboDiHKB3s0cdw@mail.gmail.com>
Subject: Re: udelay function delays the wrong time interval in multiprocessor
 system, if ARCH_HAS_READ_CURRENT_TIMER is not defined and on current timer is used.
From: chpoph <chpoph@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, will.deacon@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 2:14 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> We don't support different CPUs running at different frequencies with
> the delay loop.  Sorry.

Does it means that a timer-based delay implementation must be used to
get an accurate delay in SMP. I think it should print a warning
message if the CPU delay loop is used in SMP.  In my system, the wrong
delay interval fluctuated with CPU frequencies caused a control
problem.
