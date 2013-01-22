Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab3AVXhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:37:38 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:57121 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3AVXhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:37:34 -0500
MIME-Version: 1.0
In-Reply-To: <20121121211529.GA27696@obsidianresearch.com>
References: <20121121211529.GA27696@obsidianresearch.com>
Date: Tue, 22 Jan 2013 17:29:23 -0600
Message-ID: <CAM0nabE9qORsD1bMDm6EUZogPqb2m-X8rZ-xVqJecM7oJyaciw@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH] TPM: Work around buggy TPMs that block
 during continue self test
From: Kent Yoder <shpedoikal@gmail.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Wed, Nov 21, 2012 at 3:15 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> We've been testing an alternative TPM for our embedded products and
> found random kernel boot failures due to time outs after the continue
> self test command.
>
> This was happening randomly, and has been *very* hard to track down, but it
> looks like with this chip there is some kind of race with the tpm_tis_status()
> check of TPM_STS_COMMAND_READY. If things get there 'too fast' then
> it sees the chip is ready, or tpm_tis_ready() works. Otherwise it takes
> somewhere over 400ms before the chip will return TPM_STS_COMMAND_READY.
>
> Adding some delay after tpm_continue_selftest() makes things reliably
> hit the failure path, otherwise it is a crapshot.

  I've staged this patch here, please test:

https://github.com/shpedoikal/linux.git tpmdd-01-22-13

Thanks,
Kent
