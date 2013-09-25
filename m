Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab3IYMBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:01:34 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:51513 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755198Ab3IYMBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:01:32 -0400
Date: Wed, 25 Sep 2013 13:01:29 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, leif.lindholm@linaro.org,
        grant.likely@linaro.org, msalter@redhat.com
Subject: Re: [PATCH 09/18] Move unicode to ASCII conversion to shared
 function.
Message-ID: <20130925120129.GG21381@console-pimps.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
 <1379889942-3135-10-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379889942-3135-10-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Sep, at 03:45:33PM, Roy Franz wrote:
> Move the open-coded conversion to a shared function for
> use by all architectures.  Change the allocation to prefer
> a high address for ARM, as this is required to avoid conflicts
> with reserved regions in low memory.  We don't know the specifics
> of these regions until after we process the command line and
> device tree.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |   43 ++++-------------------
>  drivers/firmware/efi/efi-stub-helper.c |   58 ++++++++++++++++++++++++++++++++
>  2 files changed, 64 insertions(+), 37 deletions(-)

[...]

> +/* Convert the unicode UEFI command line to ASCII to pass to kernel.
> + * Size of memory allocated return in *cmd_line_len.
> + * Returns NULL on error.
> + */

I futzed with the comments in this patch too.

-- 
Matt Fleming, Intel Open Source Technology Center
