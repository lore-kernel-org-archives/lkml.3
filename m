Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaJULHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:07:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40665 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbaJULHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:07:46 -0400
Date: Tue, 21 Oct 2014 13:07:25 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Markos Chandras <markos.chandras@imgtec.com>
Cc: linux-mips@linux-mips.org, Jonathan Corbet <corbet@lwn.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: ptp: Fix build failure on MIPS cross
 builds
Message-ID: <20141021110724.GA16479@netboy>
References: <1413794538-28465-1-git-send-email-markos.chandras@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413794538-28465-1-git-send-email-markos.chandras@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 09:42:18AM +0100, Markos Chandras wrote:
> diff --git a/Documentation/ptp/Makefile b/Documentation/ptp/Makefile
> index 293d6c09a11f..397c1cd2eda7 100644
> --- a/Documentation/ptp/Makefile
> +++ b/Documentation/ptp/Makefile
> @@ -1,5 +1,15 @@
>  # List of programs to build
> +ifndef CROSS_COMPILE
>  hostprogs-y := testptp
> +else
> +# MIPS system calls are defined based on the -mabi that is passed
> +# to the toolchain which may or may not be a valid option
> +# for the host toolchain. So disable testptp if target architecture
> +# is MIPS but the host isn't.
> +ifndef CONFIG_MIPS
> +hostprogs-y := testptp
> +endif
> +endif

It seems like a shame to simply give up and not compile this at all.
Is there no way to correctly cross compile this for MIPS?

Thanks,
Richard
