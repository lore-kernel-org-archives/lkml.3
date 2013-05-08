Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab3EHVst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:48:49 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52094 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3EHVss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:48:48 -0400
X-Nat-Received: from [202.181.97.72]:51795 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1368049704.3749
To: clmason@fusionio.com, cl@linux.com
Cc: penberg@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        tony@atomide.com
Subject: Re: [PATCH] Fix crash during slab init
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20130508003022.GS28721@atomide.com>
	<20130508042422.GU28721@atomide.com>
	<20130508181353.23991.17852@localhost.localdomain>
	<0000013e85852607-fd84223c-112e-46b9-a60f-73d9597d90ac-000000@email.amazonses.com>
	<20130508195628.4271.97115@localhost.localdomain>
In-Reply-To: <20130508195628.4271.97115@localhost.localdomain>
Message-Id: <201305090648.HHG43284.FOFHOOVLStMFQJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 9 May 2013 06:48:23 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 08052013 #9920543, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> Commit 8a965b3b introduced a regression that caused us to crash early
> during boot.  The commit was introducing ordering of slab creation,
> making sure two odd-sized slabs were created after specific powers of
> two sizes.
> 
> But, if any of the  power of two slabs were created earlier during boot,
> slabs at index 1 or 2 might not get created at all.  This patch makes
> sure none of the slabs get skipped.
> 
> Tony Lindgren bisected this down to the offending commit, which really
> helped because bisect kept bringing me to almost but not quite this one.
> 
> Signed-off-by: Chris Mason <chris.mason@fusionio.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

This patch keeps my x86_32 debug kernel boots fine. Thank you.
