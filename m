Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbaGAUqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:46:24 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:43379 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbaGAUqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:46:21 -0400
Date: Tue, 1 Jul 2014 16:46:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Filipe Brandenburger <filbranden@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, Zhengyu He <hzy@google.com>,
        Greg Thelen <gthelen@google.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] core: fix typo in percpu read_mostly section
Message-ID: <20140701204617.GC12459@htj.dyndns.org>
References: <1403547365-13428-1-git-send-email-filbranden@google.com>
 <1404241907-27093-1-git-send-email-filbranden@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404241907-27093-1-git-send-email-filbranden@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 12:11:47PM -0700, Filipe Brandenburger wrote:
> From: Zhengyu He <hzy@google.com>
> 
> This fixes a typo that named the read_mostly section of percpu as
> readmostly. It works fine with SMP because the linker script specifies
> .data..percpu..readmostly. However, UP kernel builds don't have percpu
> sections defined and the non-percpu version of the section is called
> data..read_mostly, so .data..readmostly will float around and may break
> things unexpectedly.
> 
> Looking at the original change that introduced data..percpu..readmostly
> (commit c957ef2c59e952803766ddc22e89981ab534606f), it looks like this
> was the original intention.
> 
> Tested: Built UP kernel and confirmed the sections got merged.
> 
> - Before the patch:
> $ objdump -h vmlinux.o  | grep '\.data\.\.read.*mostly'
> 38 .data..read_mostly 00004418  0000000000000000  0000000000000000  00431ac0  2**6
> 50 .data..readmostly 00000014  0000000000000000  0000000000000000  00444000  2**3
> 
> - After the patch:
> $ objdump -h vmlinux.o  | grep '\.data\.\.read.*mostly'
> 38 .data..read_mostly 00004438  0000000000000000  0000000000000000  00431ac0  2**6
> 
> Signed-off-by: Zhengyu He <hzy@google.com>
> Signed-off-by: Filipe Brandenburger <filbranden@google.com>

Applied to percpu/for-3.16-fixes.

Thanks.

-- 
tejun
