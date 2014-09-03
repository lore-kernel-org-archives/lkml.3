Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbaICNnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:43:19 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:42217 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431AbaICNnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:43:18 -0400
Date: Wed, 3 Sep 2014 14:43:14 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3] x86: only load initrd above 4g on second try
Message-ID: <20140903134314.GG3001@console-pimps.org>
References: <1409696740-14981-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409696740-14981-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep, at 03:25:40PM, Yinghai Lu wrote:
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
> 
> Reported-by: Mantas Mikulėnas <grawity@gmail.com>
> Tested-by: Anders Darander <anders@chargestorm.se>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I'm still seeing build errors/warnings with this version,

  drivers/firmware/efi/libstub/lib.a(efi-stub-helper.o): In function `handle_cmdline_files':
  efi-stub-helper.c:(.text+0xb7a): undefined reference to `sprintf'

Please drop the second hunk.

-- 
Matt Fleming, Intel Open Source Technology Center
