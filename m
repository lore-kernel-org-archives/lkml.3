Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934866Ab3BNTT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:19:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934815Ab3BNTTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:19:55 -0500
Date: Thu, 14 Feb 2013 20:18:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: make PTRACE_GETREGSET return 32-bit regs if
	64-bit process entered kernel with int 80
Message-ID: <20130214191842.GA11620@redhat.com>
References: <511CE3D0.8000308@redhat.com> <20130214150046.GA30543@redhat.com> <511D2779.7040504@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511D2779.7040504@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, H. Peter Anvin wrote:
>
> On 02/14/2013 07:00 AM, Oleg Nesterov wrote:
>> On 02/14, Denys Vlasenko wrote:
>>>
>>> Determining personality of a ptraced process is a murky area.
>>> On x86, for years strace was looking at segment selectors,
>>> which is conceptually wrong: see, for example,
>>> https://lkml.org/lkml/2012/1/18/320
>>>
>
> One proposal that keeps being on the table is to export a regset with
> metadatam, including process mode at launch (i386, x86-64, x32).

Yes... but if this metadata includes TS_COMPAT-is-set, then strace should
do PTRACE_GETREGSET(REGSET_META) + PTRACE_GETREGSET(REGSET_GENERAL) every
time. Or REGSET_META should include META+GENERAL.

IOW, it is not clear to me what this "meta" should actually report.

Oleg.


