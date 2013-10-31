Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab3JaQJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:09:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:15682 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750709Ab3JaQJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:09:30 -0400
Date: Thu, 31 Oct 2013 12:09:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jamie Iles <jamie.iles@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] recordmcount.pl: add support for __fentry__
Message-ID: <20131031120926.112c3c26@gandalf.local.home>
In-Reply-To: <1383235198-24961-1-git-send-email-jamie.iles@oracle.com>
References: <1383235198-24961-1-git-send-email-jamie.iles@oracle.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct 2013 15:59:58 +0000
Jamie Iles <jamie.iles@oracle.com> wrote:

> With gcc 4.6.0 the -mfentry feature places the function profiling call
> at the start of the function. When this is used, the call is to
> __fentry__ and not mcount.
> 
> Based on 48bb5dc6cd9d30fe0d594947563da1f8bd9abada (ftrace: Make
> recordmcount.c handle __fentry__).

Why? All current users of __fentry__ use the C version of recordmcount.
This just slows down the few archs that still use recordmcount.pl.

-- Steve

> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Jamie Iles <jamie.iles@oracle.com>
> ---
>  scripts/recordmcount.pl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index a674fd5..6460fc68 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -214,7 +214,7 @@ $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
>  $weak_regex = "^[0-9a-fA-F]+\\s+([wW])\\s+(\\S+)";
>  $section_regex = "Disassembly of section\\s+(\\S+):";
>  $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
> -$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
> +$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s(mcount|__fentry__)\$";
>  $section_type = '@progbits';
>  $mcount_adjust = 0;
>  $type = ".long";

