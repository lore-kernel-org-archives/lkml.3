Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaI2Ral (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 13:30:41 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:45509 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbaI2Rah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 13:30:37 -0400
From: Andy Lutomirski <luto@amacapital.net>
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <54299737.50701@mit.edu>
Date: Mon, 29 Sep 2014 10:30:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Chuck Ebbert <cebbert.lkml@gmail.com>, Anish Bhatt <anish@chelsio.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, sebastian@fds-team.de
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
References: <1411674171-24442-1-git-send-email-anish@chelsio.com> <20140925180005.356089de@as>
In-Reply-To: <20140925180005.356089de@as>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 04:00 PM, Chuck Ebbert wrote:
> #include <stdio.h>
> #include <unistd.h>
> 
> int main()
> {
> 	asm volatile("pushfq           \n\t" \
> 		     "pop %rax         \n\t" \
> 		     "or $0x4000,%rax  \n\t" \
> 		     "push %rax        \n\t" \
> 		     "popfq            \n\t");

You're missing clobbers here.  But fixing that has no effect.

> 	sleep(1);
> 
> 	return 0;
> }

