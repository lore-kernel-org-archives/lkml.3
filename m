Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaF2H4D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 03:56:03 -0400
Received: from smtp-out-099.synserver.de ([212.40.185.99]:1034 "EHLO
	smtp-out-099.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaF2H4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 03:56:01 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10088
Message-ID: <53AFC68C.5010105@metafoo.de>
Date: Sun, 29 Jun 2014 09:55:56 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH 1/1] MIPS: jz4740: remove unnecessary null test before
 debugfs_remove
References: <1404026663-3510-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1404026663-3510-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2014 09:24 AM, Fabian Frederick wrote:
> Fix checkpatch warning:
> WARNING: debugfs_remove(NULL) is safe this check is probably not required
>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: linux-mips@linux-mips.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.

> ---
>   arch/mips/jz4740/clock-debugfs.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/mips/jz4740/clock-debugfs.c b/arch/mips/jz4740/clock-debugfs.c
> index a8acdef..325422d0 100644
> --- a/arch/mips/jz4740/clock-debugfs.c
> +++ b/arch/mips/jz4740/clock-debugfs.c
> @@ -87,8 +87,7 @@ void jz4740_clock_debugfs_add_clk(struct clk *clk)
>   /* TODO: Locking */
>   void jz4740_clock_debugfs_update_parent(struct clk *clk)
>   {
> -	if (clk->debugfs_parent_entry)
> -		debugfs_remove(clk->debugfs_parent_entry);
> +	debugfs_remove(clk->debugfs_parent_entry);
>
>   	if (clk->parent) {
>   		char parent_path[100];
>

