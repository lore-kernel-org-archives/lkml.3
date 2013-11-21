Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab3KUTHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:07:17 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41526 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754677Ab3KUTHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:07:16 -0500
X-Sasl-enc: JjGdXR/60DIAb7IWynHcOgWiPQIuuPOj8LZaacEoYN8N 1385060831
Date: Thu, 21 Nov 2013 11:07:10 -0800
From: Greg KH <greg@kroah.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org
Subject: Re: [PATCH 5/6] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20131121190710.GD17070@kroah.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-6-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384969851-7251-6-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 12:50:50PM -0500, Vivek Goyal wrote:
> This is loader specific code which can load bzImage and set it up for
> 64bit entry. This does not take care of 32bit entry or real mode entry
> yet.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/include/asm/kexec-bzimage.h |   12 +
>  arch/x86/include/asm/kexec.h         |   26 +++
>  arch/x86/kernel/Makefile             |    2 +
>  arch/x86/kernel/kexec-bzimage.c      |  375 ++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/machine_kexec_64.c   |    4 +-
>  arch/x86/kernel/purgatory_entry_64.S |  119 +++++++++++
>  6 files changed, 537 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/include/asm/kexec-bzimage.h
>  create mode 100644 arch/x86/kernel/kexec-bzimage.c
>  create mode 100644 arch/x86/kernel/purgatory_entry_64.S

Wow, that's surprisingly small, nice job.

What do you mean by the "real mode entry"?  Do we need to care about
that because we aren't falling back to real mode when executing this,
are we?  Or does that just happen for 32bit kernels?

thanks,

greg k-h
