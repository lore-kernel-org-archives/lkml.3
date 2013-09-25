Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3IYT0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:26:53 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:45544 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3IYT0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:26:52 -0400
Message-ID: <524338F6.2090508@tilera.com>
Date: Wed, 25 Sep 2013 15:26:46 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: include: asm: use 'long long' instead of 'u64'
 for atomic64_t and its related functions
References: <52426310.4020204@asianux.com>
In-Reply-To: <52426310.4020204@asianux.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/2013 12:14 AM, Chen Gang wrote:
> atomic* value is signed value, and atomic* functions need also process
> signed value (parameter value, and return value), so use 'long long'
> instead of 'u64'.
>
> After replacement, it will also fix a bug for atomic64_add_negative():
> "u64 is never less than 0".
>
> The modifications are:
>
>   in vim, use "1,% s/\<u64\>/long long/g" command.
>   remove redundant '__aligned(8)' and a type case '(u64 *)'.
>   be sure of 80 (and macro '\') columns limitation after replacement.
>
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/tile/include/asm/atomic.h    |    5 +++--
>  arch/tile/include/asm/atomic_32.h |   27 +++++++++++++++------------
>  arch/tile/include/asm/cmpxchg.h   |   28 +++++++++++++++++-----------
>  arch/tile/lib/atomic_32.c         |    8 ++++----
>  4 files changed, 39 insertions(+), 29 deletions(-)

Thanks!  Taken into the tile tree for 3.12.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

