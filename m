Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaAXTet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:34:49 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:48205 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaAXTeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:34:46 -0500
MIME-Version: 1.0
In-Reply-To: <52E2A866.1050400@codeaurora.org>
References: <1390581656-16372-1-git-send-email-adrienverge@gmail.com>
	<1390581656-16372-5-git-send-email-adrienverge@gmail.com>
	<20140124164343.GJ31040@mudshark.cambridge.arm.com>
	<CANsc=4UgWrFis6hi-0mXZAfery7YGDJ2F+NdZBzq6afwx_i58A@mail.gmail.com>
	<20140124171754.GM31040@mudshark.cambridge.arm.com>
	<52E2A866.1050400@codeaurora.org>
Date: Fri, 24 Jan 2014 14:34:41 -0500
Message-ID: <CANsc=4X+8He-w9wr0xbtDkJhxw8H13kk_-OV07jMZ7govTnmxQ@mail.gmail.com>
Subject: Re: [PATCH V2 4/6] ARM: Make PID_IN_CONTEXTIDR incompatible with PID_NS
From: =?UTF-8?Q?Adrien_Verg=C3=A9?= <adrienverge@gmail.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Michel Dagenais <michel.dagenais@polymtl.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/24 Will Deacon <will.deacon@arm.com>:
> I think I'd rather have the global ID than disable a potentially useful
> feature, especially since this is likely to be consumed by external trace
> tools as opposed to user-space tasks.

I understand.

2014/1/24 Christopher Covington <cov@codeaurora.org>:
> Would it be reasonable to make what's
> written to the CONTEXTIDR run-time configurable? If so, what would be the best
> interface for configuring it?

This is an interesting option.

An other option would be to keep the global PID in the Context ID
register, and rely on kernel support to translate virtual PID to
global PID when needed. Then, it would be possible to select a task to
trace via its PID, by asking the kernel to write its global ID to the
Context ID comparator.
