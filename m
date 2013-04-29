Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab3D2Ju7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:50:59 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:42586 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752822Ab3D2Ju5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:50:57 -0400
Date: Mon, 29 Apr 2013 12:50:48 +0300
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Subject: Re: [PATCH] openrisc: call do_notify_resume() with interrupts enabled
Message-ID: <20130429095040.GA11785@chokladfabriken.org>
References: <1367219557-11495-1-git-send-email-stefan.kristiansson@saunalahti.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367219557-11495-1-git-send-email-stefan.kristiansson@saunalahti.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 10:12:37AM +0300, Stefan Kristiansson wrote:
> A signal delivered through do_notify_resume() would cause the
> irqs_disabled() check in _local_bh_enable_ip() to be triggered.
> 
> Enable interrupts before calling do_notify_resume().
> 
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> ---
>  arch/openrisc/kernel/entry.S | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
> index d8a455e..55ffc97 100644
> --- a/arch/openrisc/kernel/entry.S
> +++ b/arch/openrisc/kernel/entry.S
> @@ -874,6 +874,7 @@ _work_pending:
>   * must be set so that the syscall restart functionality works.
>   */
>  _work_notifysig:
> +	ENABLE_INTERRUPTS(r29)
>  	l.jal	do_notify_resume
>  	 l.ori	r3,r1,0		  /* pt_regs */
>  

I just realised that this one-liner isn't quite enough,
the flags that are used in do_notify_resume() has to be read with
interrupts off.
Revised patch coming up.

Stefan
