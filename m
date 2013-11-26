Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab3KZLRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:17:14 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:56880 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab3KZLRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:17:10 -0500
Date: Tue, 26 Nov 2013 12:17:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jason Baron <jbaron@akamai.com>
Cc: benh@kernel.crashing.org, paulus@samba.org, ralf@linux-mips.org,
        akpm@linux-foundation.org, mpe@ellerman.id.au,
        felipe.contreras@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 v3] build in panic_timeout value
Message-ID: <20131126111706.GA2410@gmail.com>
References: <cover.1385418410.git.jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1385418410.git.jbaron@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Baron <jbaron@akamai.com> wrote:

> Hi,
> 
> I've now separated out the arch bits into separate patches. 
> Hopefully, it makes review easier. I also didn't address moving the 
> 'panic_timeout' command-line parameter up as an 'early_param()'. I 
> think it might make sense to move it up, especially for distro 
> kernels, but its not a need here, so I didn't want to just shove it 
> in. If needed, I think it can come in separately, as it shoudn't 
> affect this series.

The series looks good to me, I've applied the patches to 
tip:core/debug.

If Felipe Contreras's fix patch looks good to you then it would also 
be nice if you could send me that as well, on top of your patches.

That fix patch had only one remaining bug/problem, last I checked: if 
panic_timeout is turned into an early_param() then pause_on_oops 
should obviously also be turned into an early param. Changing just one 
of these parameters would be inconsistent and would lead to assymetric 
behavior in the early-crash case.

Thanks,

	Ingo
