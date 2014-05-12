Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaELEMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 00:12:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:35742 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbaELEMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 00:12:17 -0400
Message-ID: <1399867920.17624.73.camel@pasglop>
Subject: Re: [PATCH] powerpc: Fix "attempt to move .org backwards" error
 (again)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>
Date: Mon, 12 May 2014 14:12:00 +1000
In-Reply-To: <1399680478-4970-1-git-send-email-linux@roeck-us.net>
References: <1399680478-4970-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 17:07 -0700, Guenter Roeck wrote:
> Commit 4e243b7 (powerpc: Fix "attempt to move .org backwards" error) fixes the
> allyesconfig build by moving machine_check_common to a different location.
> While this fixes most of the errors, both allmodconfig and allyesconfig still
> fail as follows.
> 
> arch/powerpc/kernel/exceptions-64s.S:1315: Error: attempt to move .org backwards
> 
> Fix by moving machine_check_common after the offending address.

This suffers from the same problem as previous attempts, on some of my
test configs I get:

arch/powerpc/kernel/head_64.o:(__ftr_alt_97+0xb0): relocation truncated to fit: R_PPC64_REL14 against `.text'+1c90
make[1]: *** [vmlinux] Error 1
make: *** [sub-make] Error 2

IE, it breaks currently working configs.

So we need to move more things around and I haven't had a chance to
sort it out.

Cheers,
Ben.


