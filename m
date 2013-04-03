Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708Ab3DCNJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:09:08 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55087 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758652Ab3DCNJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:09:06 -0400
Message-ID: <515C29EE.8050008@console-pimps.org>
Date: Wed, 03 Apr 2013 14:09:02 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: matt.fleming@intel.com, ben@decadent.org.uk, jwboyer@redhat.com,
        linux-efi@vger.kernel.org, seth.forshee@canonical.com,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/2] efi: Determine how much space is used by boot services-only
 variables
References: <515150EC.7040203@redhat.com> <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/13 16:13, Matthew Garrett wrote:
> EFI variables can be flagged as being accessible only within boot services.
> This makes it awkward for us to figure out how much space they use at
> runtime. In theory we could figure this out by simply comparing the results
> from QueryVariableInfo() to the space used by all of our variables, but
> that fails if the platform doesn't garbage collect on every boot. Thankfully,
> calling QueryVariableInfo() while still inside boot services gives a more
> reliable answer. This patch passes that information from the EFI boot stub
> up to the efivars code, letting us calculate a reasonably accurate value.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  arch/x86/boot/compressed/eboot.c      | 47 +++++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/efi.h            | 10 ++++++++
>  arch/x86/include/uapi/asm/bootparam.h |  1 +
>  arch/x86/platform/efi/efi.c           | 21 ++++++++++++++++
>  drivers/firmware/efivars.c            | 29 +++++++++++++++++++++
>  5 files changed, 108 insertions(+)

We're fixing a regression in efivars.c, but only for those users that
boot via the EFI boot stub? That seems likely to upset some people.

Introducing new features via the EFI boot stub is fine, and working
around firmware bugs so that we can use some feature is also cool, but
we can't start fixing regressions from other subsystems in the EFI boot
stub.

-- 
Matt Fleming, Intel Open Source Technology Center
