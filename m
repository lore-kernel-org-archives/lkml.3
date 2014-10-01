Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaJAFJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 01:09:25 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:62783 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaJAFJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 01:09:23 -0400
Message-ID: <542B8C7F.70108@fds-team.de>
Date: Wed, 01 Oct 2014 07:09:19 +0200
From: Sebastian Lackner <sebastian@fds-team.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
References: <cover.1412138935.git.luto@amacapital.net> <0e906bdeba3660c9766248d3d7229e78a423ca5b.1412138935.git.luto@amacapital.net>
In-Reply-To: <0e906bdeba3660c9766248d3d7229e78a423ca5b.1412138935.git.luto@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	testl $X86_EFLAGS_NT,EFLAGS(%rsp)	/* saved EFLAGS match cpu */
> +	jz 1f
> +	pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_FIXED)
> +	popfq_cfi
> +1:
> +

Do you think it makes sense to change the order here, so that no jump happens if
NT is not set (which happens a bit more often, than the other way round)? Just a
guess though, haven't measured if pipeline effects have such a big influence in this
case. ;)

