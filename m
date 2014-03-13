Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaCMW7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:59:46 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:41898 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaCMW7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:59:44 -0400
MIME-Version: 1.0
In-Reply-To: <53222F1A.8090205@oracle.com>
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
	<5321CBDA.1060705@oracle.com>
	<CA+55aFwDKSKyxC4rTBiFMRVr6xYtL96ZYCQqNSVLJV0-=FLTUg@mail.gmail.com>
	<53222F1A.8090205@oracle.com>
Date: Thu, 13 Mar 2014 15:59:43 -0700
X-Google-Sender-Auth: KLikCDa07wcF_T1dRS7sW7EF47U
Message-ID: <CA+55aFxi5VQFu6_MVaVWhwj+bo-orQUmsKRakr_1Txfu1bEcpg@mail.gmail.com>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 3:20 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> I'll fix it up and re-send this patch.

The problem (as you will find out) is that "addr2line" doesn't take
symbolic names.

So either addr2line needs to be improved (which really would be a good
idea regardless), or your script needs to use "nm" or "gdb" or
something to first translate the symbol+off into a hex number (which
will not match the kernel-provided hex number when base randomization
is in effect, but it will match the pre-randomized data in the vmlinux
file, so then addr2line would work).

              Linus
