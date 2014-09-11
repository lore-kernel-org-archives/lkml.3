Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaIKPCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:02:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54052 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636AbaIKPCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:02:49 -0400
Date: Thu, 11 Sep 2014 16:02:12 +0100
From: Will Deacon <will.deacon@arm.com>
To: Yang Yingliang <yangyingliang@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH v2] arm64: add guard macros of unistd.h to prevent double
 inclusion
Message-ID: <20140911150212.GP6158@arm.com>
References: <1410235185-16652-1-git-send-email-yangyingliang@huawei.com>
 <20140909123938.GL1754@arm.com>
 <54115583.8080306@huawei.com>
 <5411698E.3000402@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411698E.3000402@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 10:21:18AM +0100, Yang Yingliang wrote:
> From: Yang Yingliang <yangyingliang@huawei.com>
> 
> Add guard macros for uapi/asm/unistd.h, asm/unistd.h and
> asm/unistd32.h.

Hmm, so I applied this and now my machine panics when we hit userspace. I
think the issue is that we no longer generate our syscall table in
arch/arm64/kernel/sys.c, because unistd.h is already included via
linux/syscalls.h but without the __SYSCALL definition.

So, a couple of questions:

  (1) Is the lack of header guards actually causing you a problem?
  (2) How did you test this?

I've dropped the patch.

Will
