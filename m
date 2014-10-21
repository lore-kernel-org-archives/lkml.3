Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbaJUWFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:05:15 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:46706 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933696AbaJUWFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:05:12 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8:ee7:39bc:72a7:a0a6:e1f0]
In-Reply-To: <20141021182757.GA3960@localhost.localdomain>
References: <1413794538-28465-1-git-send-email-markos.chandras@imgtec.com>
 <20141021110724.GA16479@netboy> <20141021.123544.9516812519754063.davem@davemloft.net>
 <544690CB.4030307@gmail.com> <20141021182757.GA3960@localhost.localdomain>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 21 Oct 2014 18:04:51 -0400
Message-ID: <CAOFdcFNYHgupvMChb4NedMsUMAOmE8k0D_F5eRjL-8H8ft=eRw@mail.gmail.com>
Subject: Re: [PATCH] Documentation: ptp: Fix build failure on MIPS cross builds
To: Richard Cochran <richardcochran@gmail.com>
Cc: David Daney <ddaney.cavm@gmail.com>, David Miller <davem@davemloft.net>,
        markos.chandras@imgtec.com, linux-mips@linux-mips.org, corbet@lwn.net,
        netdev@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 2:27 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Tue, Oct 21, 2014 at 09:58:51AM -0700, David Daney wrote:
>> What I don't understand is why we are using hostprogs in this
>> Makefile.  Isn't this a program that would run on the target, not
>> the build host?
>
> Yes.
>
> Peter, could you please fix it?


The intention of these changes was to generate more compiliation
coverage for code in Documentation/
The underlying issue is that this doesn't work for cross-compiling
because kbuild doesn't have cross-compile support for userspace code.
I submitted a patch to disable building Documentation when
cross-compiling, as the consensus in the thread that resulted in that
patch (https://lkml.org/lkml/2014/10/8/510) was that implementing
targetprogs in kbuild was not currently worth it.
I can try to take a crack at adding targetprogs support, but I'm
rather busy right now, so it may take a little while.

Thanks,

Peter
