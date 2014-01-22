Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaAVAcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 19:32:36 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:62070 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbaAVAcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 19:32:35 -0500
Message-ID: <52DF119D.6090506@twiddle.net>
Date: Tue, 21 Jan 2014 16:32:29 -0800
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
CC: linux-arch@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 22/73] alpha: don't use module_init for non-modular core
 code
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com> <1390339396-3479-23-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1390339396-3479-23-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 01:22 PM, Paul Gortmaker wrote:
> The srm console is always built in.  It will never be modular,
> so using module_init as an alias for __initcall is rather
> misleading.
> 
> Fix this up now, so that we can relocate module_init from
> init.h into module.h in the future.  If we don't do this, we'd
> have to add module.h to obviously non-modular code, and that
> would be a worse thing.
> 
> Direct use of __initcall is discouraged, vs prioritized ones.
> Use of device_initcall is consistent with what __initcall
> maps onto, and hence does not change the init order, making the
> impact of this change zero.   Should someone with real hardware
> for boot testing want to change it later to arch_initcall or
> console_initcall, they can do that at a later date.
> 
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Matt Turner <mattst88@gmail.com>
> Cc: linux-alpha@vger.kernel.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  arch/alpha/kernel/srmcons.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Reviewed-by: Richard Henderson <rth@twiddle.net>


r~
