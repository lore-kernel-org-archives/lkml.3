Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbaLBB23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 20:28:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbaLBB22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 20:28:28 -0500
Date: Mon, 1 Dec 2014 17:28:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: bp@suse.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, david.vrabel@citrix.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH] x86, microcode: Don't initialize microcode code on
 paravirt
Message-ID: <20141202012827.GA22525@kroah.com>
References: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 04:27:44PM -0500, Boris Ostrovsky wrote:
> Paravirtual guests are not expected to load microcode into processors
> and therefore it is not necessary to initialize microcode loading
> logic.
> 
> In fact, under certain circumstances initializing this logic may cause
> the guest to crash. Specifically, 32-bit kernels use __pa_nodebug()
> macro which does not work in Xen (the code path that leads to this macro
> happens during resume when we call mc_bp_resume()->load_ucode_ap()
> ->check_loader_disabled_ap())
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  arch/x86/kernel/cpu/microcode/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
