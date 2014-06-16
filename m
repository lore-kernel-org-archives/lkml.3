Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaFPXSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:18:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaFPXSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:18:05 -0400
Date: Mon, 16 Jun 2014 16:18:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Hagen Paul Pfeifer <hagen@jauu.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include: kernel.h: rewrite min3, max3 and clamp using
 min and max
Message-Id: <20140616161804.bb06ed842f59371c031d1252@linux-foundation.org>
In-Reply-To: <1402952842-12886-1-git-send-email-mina86@mina86.com>
References: <1402952842-12886-1-git-send-email-mina86@mina86.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014 23:07:22 +0200 Michal Nazarewicz <mina86@mina86.com> wrote:

> It appears that gcc is better at optimising a double call to min
> and max rather than open coded min3 and max3.  This can be observed
> here:
> 
> ...
>
> Furthermore, after ___make allmodconfig && make bzImage modules___ this is the
> comparison of image and modules sizes:
> 
>     # Without this patch applied
>     $ ls -l arch/x86/boot/bzImage **/*.ko |awk '{size += $5} END {print size}'
>     350715800
> 
>     # With this patch applied
>     $ ls -l arch/x86/boot/bzImage **/*.ko |awk '{size += $5} END {print size}'
>     349856528

We saved nearly a megabyte by optimising min3(), max3() and clamp()? 

I'm counting a grand total of 182 callsites for those macros.  So the
saving is 4700 bytes per invokation?  I don't believe it...


