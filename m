Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaIDKBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:01:46 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58325 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaIDKBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:01:44 -0400
Date: Thu, 4 Sep 2014 11:01:37 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Message-ID: <20140904100137.GK3001@console-pimps.org>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep, at 09:50:07PM, Yinghai Lu wrote:
> Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
> loaded above 4G"), the kernel freezes at the earliest possible moment
> when trying to boot via UEFI on Asus laptop.
> 
> Revert to old way to load initrd under 4G on first try,
> second try will use above 4G buffer when initrd is too big
> and does not fit under 4G.
> 
> -v2: add print out for second try, and print out files buf address.
> -v3: can not snprintf
> -v4: drop address print out for files buf
> 
> Reported-by: Mantas Mikulėnas <grawity@gmail.com>
> Tested-by: Anders Darander <anders@chargestorm.se>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/boot/compressed/eboot.c |   18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)

Thanks, I've picked this up and expanded on the commit message because a
lot of useful information was discussed on the mailing list that we
should definitely include.

  http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=urgent&id=b524e05df6d466af2f7eea1f044369109e48e641

-- 
Matt Fleming, Intel Open Source Technology Center
