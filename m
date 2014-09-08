Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaIHQIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:08:11 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46711 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaIHQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:08:09 -0400
Date: Mon, 8 Sep 2014 17:08:05 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: matt.fleming@intel.com, Mark Rustad <mark.d.rustad@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] efi: Resolve some shadow warnings
Message-ID: <20140908160805.GT3001@console-pimps.org>
References: <1410008573-444-1-git-send-email-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410008573-444-1-git-send-email-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Sep, at 06:02:53AM, Jeff Kirsher wrote:
> From: Mark Rustad <mark.d.rustad@intel.com>
> 
> It is a really bad idea to declare variables or parameters that
> have the same name as common types. It is valid C, but it gets
> surprising if a macro expansion attempts to declare an inner
> local with that type. Change the local names to eliminate the
> hazard.
> 
> Change s16 => str16, s8 => str8.
> 
> This resolves warnings seen when using W=2 during make, for instance:
> 
> drivers/firmware/efi/vars.c: In function ‘dup_variable_bug’:
> drivers/firmware/efi/vars.c:324:44: warning: declaration of ‘s16’ shadows a global declaration [-Wshadow]
>  static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_guid,
> 
> drivers/firmware/efi/vars.c:328:8: warning: declaration of ‘s8’ shadows a global declaration [-Wshadow]
>   char *s8;
> 
> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Thanks Jeff, Mark, applied.

-- 
Matt Fleming, Intel Open Source Technology Center
