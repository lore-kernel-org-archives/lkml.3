Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaEGVgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:36:13 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:48140 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaEGVgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:36:11 -0400
Date: Wed, 7 May 2014 14:35:51 -0700
From: Larry Bassel <larry.bassel@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Larry Bassel <larry.bassel@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH v2 2/2] arm64: enable context tracking
Message-ID: <20140507213550.GA10142@ubuette>
References: <1399419149-26685-1-git-send-email-larry.bassel@linaro.org>
 <1399419149-26685-3-git-send-email-larry.bassel@linaro.org>
 <20140507101709.GE18456@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507101709.GE18456@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07 May 14 11:17, Will Deacon wrote:
> On Wed, May 07, 2014 at 12:32:29AM +0100, Larry Bassel wrote:
> > Make calls to ct_user_enter when the kernel is exited
> > and ct_user_exit when the kernel is entered (in el0_da,
> > el0_ia, el0_svc, el0_irq).
> 
> Why only these entry points? I can reschedule after any exception from EL0,
> so I'd expect all exceptions from userspace to need annotating, no?
> 
> > These macros expand to function calls which will only work
> > properly if el0_sync and related code has been rearranged
> > (in a previous patch of this series).
> > 
> > In order to avoid saving registers, the slow syscall path
> > is forced (as x86 does).
> 
> ... and if you decide to handle undef exceptions, I think you'll need
> the register saving too, in case the kernel needs to perform emulation.

These are excellent points, I will rework the patch and submit v3.

Thanks for the feedback.

> 
> Will

Larry
