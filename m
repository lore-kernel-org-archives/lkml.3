Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaFEVtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:49:55 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaFEVtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:49:52 -0400
Message-ID: <5390E5FD.5030400@nod.at>
Date: Thu, 05 Jun 2014 23:49:49 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Honggang Li <enjoymindful@gmail.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove csum_partial_copy_generic_i386 to clean up exception
 table
References: <538F275B.7000508@nod.at> <1401941724-6703-1-git-send-email-enjoymindful@gmail.com> <1401941724-6703-2-git-send-email-enjoymindful@gmail.com>
In-Reply-To: <1401941724-6703-2-git-send-email-enjoymindful@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.06.2014 06:15, schrieb Honggang Li:
> arch/x86/um/checksum_32.S had been copy & paste from x86. When build
> x86 uml, csum_partial_copy_generic_i386 mess up the exception table.
> In fact, exception table dose not work in uml kernel.

Are you sure that exception tables do not work on UML?
I said, I'm not sure. Can you please find out?

In arch/um/kernel/trap.c:segv() we have the mechanism for it:
        else if (!is_user && arch_fixup(ip, regs))
                goto out;

The interesting question is, is this by design or was it just copy&pasted from x86
many moons ago? :)

> And csum_partial_copy_generic_i386 never been called. So, delete it.

I like such clean ups. :-)

Thanks,
//richard
