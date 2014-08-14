Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaHNIyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:54:17 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:42721 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbaHNIyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:54:13 -0400
Date: Thu, 14 Aug 2014 09:54:09 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v2] firmware: Do not use WARN_ON(!spin_is_locked())
Message-ID: <20140814085409.GX15082@console-pimps.org>
References: <1407954094-26126-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407954094-26126-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug, at 11:21:34AM, Guenter Roeck wrote:
> spin_is_locked() always returns false for uniprocessor configurations
> in several architectures, so do not use WARN_ON with it.
> Use lockdep_assert_held() instead to also reduce overhead in
> non-debug kernels.
> 
> Cc: Matt Fleming <matt.fleming@intel.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Use lockdep_assert_held instead of WARN_ON_SMP.
> 
>  drivers/firmware/efi/vars.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Thanks Guenter, applied!

-- 
Matt Fleming, Intel Open Source Technology Center
