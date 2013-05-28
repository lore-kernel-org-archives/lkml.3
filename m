Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab3E1WJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 18:09:57 -0400
Received: from mail-la0-f68.google.com ([209.85.215.68]:49941 "EHLO
	mail-la0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab3E1WJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 18:09:56 -0400
MIME-Version: 1.0
In-Reply-To: <CABQQNFFAxX3jV4h83g1bhNkwEu2=4R2kqk4E5QAPirB=N3dTAw@mail.gmail.com>
References: <CABQQNFFAxX3jV4h83g1bhNkwEu2=4R2kqk4E5QAPirB=N3dTAw@mail.gmail.com>
Date: Tue, 28 May 2013 18:09:54 -0400
Message-ID: <CABQQNFHtUKNnihkkpsoE03O7Za=YNOEGUMyPktt=KY8CMCj6qQ@mail.gmail.com>
Subject: Re: [PATCH]: Kernel Oops Priority Level in <linux/printk.h>
From: Christopher Sacchi <christophersacchi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: There's a space after #endif at the end.

On Tue, May 28, 2013 at 6:08 PM, Christopher Sacchi
<christophersacchi@gmail.com> wrote:
> Here is a patch for linux-3.10-rc2 that adds a KERN_OOPS priority
> level as a handler for if a kernel oops occurs, (this priority can be
> used for a message to the kernel log,) and it is applied to
> linux/printk.h in the include directory. It has been checked and has 2
> warnings with no errors. The patch is between the two double-dashes.
>
>
>
> --
> Signed-Off-By: Christopher P. Sacchi <christophersacchi@gmail.com>
>  --- include/linux/printk.h     2013-05-28 17:38:52.030426439 -0400
> +++ include/linux/printk.h  2013-05-28 17:39:21.530055578 -0400
> @@ -395,4 +395,8 @@ static inline void print_hex_dump_bytes(
> print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, rowsize,
>                            groupsize, buf, len, ascii)
> #endif /* defined(CONFIG_DYNAMIC_DEBUG) */
> +
> +/* Define an oops priority level. */
> +#define pr_oops(fmt, ...) \
> +          printk(KERN_OOPS pr_fmt(fmt), ##__VA_ARGS__)
> +
> #endif
> --
