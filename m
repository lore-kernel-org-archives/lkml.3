Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab3LEU4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:56:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:29133 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751414Ab3LEU4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:56:10 -0500
Date: Thu, 5 Dec 2013 15:56:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tony Lu <zlu@tilera.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>, <fengguang.wu@intel.com>,
        Jamie Iles <jamie.iles@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: default to tilegx if ARCH=tile is specified
Message-ID: <20131205155607.5b87d90e@gandalf.local.home>
In-Reply-To: <201312052045.rB5KjrBv019932@farm-0012.internal.tilera.com>
References: <201312052045.rB5KjrBv019932@farm-0012.internal.tilera.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013 15:36:54 -0500
Tony Lu <zlu@tilera.com> wrote:

> This matches the existing behavior in arch/tile/Makefile for defconfig.
> 

If you want to pull this in through the tile tree, you can add my:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Or I can take it. Either way is fine with me.

-- Steve

> Reported-by: fengguang.wu@intel.com
> Signed-off-by: Tony Lu <zlu@tilera.com>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> Chris Metcalf will push this change via the tile tree.
> 
>  scripts/recordmcount.pl | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index d0da66396f62..91280b82da08 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -364,7 +364,8 @@ if ($arch eq "x86_64") {
>  } elsif ($arch eq "blackfin") {
>      $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s__mcount\$";
>      $mcount_adjust = -4;
> -} elsif ($arch eq "tilegx") {
> +} elsif ($arch eq "tilegx" || $arch eq "tile") {
> +    # Default to the newer TILE-Gx architecture if only "tile" is given.
>      $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s__mcount\$";
>      $type = ".quad";
>      $alignment = 8;

