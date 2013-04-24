Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab3DXUpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:45:33 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:32597 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab3DXUpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:45:32 -0400
Message-ID: <5178446B.4050901@tilera.com>
Date: Wed, 24 Apr 2013 16:45:31 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Simon Marchi <simon.marchi@polymtl.ca>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: Fix syscall return value passed to tracepoint
References: <1366210882-27109-1-git-send-email-simon.marchi@polymtl.ca>
In-Reply-To: <1366210882-27109-1-git-send-email-simon.marchi@polymtl.ca>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/2013 11:01 AM, Simon Marchi wrote:
> Currently the syscall number is passed, but it should be the return
> value, which is kept in r0.
>
> Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
> ---
> This patch applies on Chris Metcalf's tree:
>   http://git.kernel.org/cgit/linux/kernel/git/cmetcalf/linux-tile.git
>
> arch/tile/include/uapi/arch/abi.h |    2 ++
>  arch/tile/kernel/ptrace.c         |    2 +-
>  2 files changed, 3 insertions(+), 1 deletions(-)

Accepted into the tile tree, but just using [0] instead of adding a new <arch/abi.h> #define.  The reason is that the compiler actually uses r0..r9 inclusive for return values, e.g. returning small structs, so I'm reluctant to call out r0 for a special name.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

