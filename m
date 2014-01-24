Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaAXRUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:20:49 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51590 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbaAXRUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:20:48 -0500
Date: Fri, 24 Jan 2014 17:17:55 +0000
From: Will Deacon <will.deacon@arm.com>
To: Adrien =?iso-8859-1?Q?Verg=E9?= <adrienverge@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Christopher Covington <cov@codeaurora.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Michel Dagenais <michel.dagenais@polymtl.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 4/6] ARM: Make PID_IN_CONTEXTIDR incompatible with
 PID_NS
Message-ID: <20140124171754.GM31040@mudshark.cambridge.arm.com>
References: <1390581656-16372-1-git-send-email-adrienverge@gmail.com>
 <1390581656-16372-5-git-send-email-adrienverge@gmail.com>
 <20140124164343.GJ31040@mudshark.cambridge.arm.com>
 <CANsc=4UgWrFis6hi-0mXZAfery7YGDJ2F+NdZBzq6afwx_i58A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANsc=4UgWrFis6hi-0mXZAfery7YGDJ2F+NdZBzq6afwx_i58A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 05:16:28PM +0000, Adrien Vergé wrote:
> 2014/1/24 Will Deacon <will.deacon@arm.com>:
> > Are you sure about this? The value we write is actually task_pid_nr, which I
> > believe to be globally unique.
> 
> You are right: the task_pid_nr is unique in the system. However when
> using namespaces, the so called "PID" is the virtual number that
> processes in different namespaces can share.
> 
> This PID is the one visible by user-space tasks, in particular
> user-space tracers and debuggers. These programs would expect to find
> the PID of the traced process in the Context ID reg, while it is not.
> I think it is better to remove confusion by making PID_IN_CONTEXTIDR
> and PID_NS incompatible.
> 
> What do you think?

I think I'd rather have the global ID than disable a potentially useful
feature, especially since this is likely to be consumed by external trace
tools as opposed to user-space tasks.

Will
