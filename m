Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaGMTZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 15:25:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55210 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaGMTZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 15:25:36 -0400
Message-ID: <53C2DD2D.2030902@infradead.org>
Date: Sun, 13 Jul 2014 12:25:33 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/6] samples: refactor Makefile
References: <20140713183636.GA17241@ravnborg.org> <1405276974-17323-1-git-send-email-sam@ravnborg.org> <1405276974-17323-2-git-send-email-sam@ravnborg.org>
In-Reply-To: <1405276974-17323-2-git-send-email-sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/14 11:42, Sam Ravnborg wrote:
> Use one line per module/program in Makefile.
> This style is easier to read/extend.
> 
> Introduce inverse xmas style sorting.

google search couldn't tell me what that means and I cannot
deduce it from the new Makefile ordering (if there is some ordering).
Please explain.

Thanks.

> This may prevent some merge conflicts in the future
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  samples/Makefile | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/samples/Makefile b/samples/Makefile
> index 1a60c62..7c08028 100644
> --- a/samples/Makefile
> +++ b/samples/Makefile
> @@ -1,4 +1,15 @@
>  # Makefile for Linux samples code
> +# Sort entries using inverse xmas style
> +#
> +# kernel modules
> +obj-$(CONFIG_SAMPLES) += hw_breakpoint/
> +obj-$(CONFIG_SAMPLES) += trace_events/
> +obj-$(CONFIG_SAMPLES) += kprobes/
> +obj-$(CONFIG_SAMPLES) += kobject/
> +obj-$(CONFIG_SAMPLES) += kfifo/
> +obj-$(CONFIG_SAMPLES) += rpmsg/
> +obj-$(CONFIG_SAMPLES) += kdb/
>  
> -obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ trace_events/ \
> -			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/
> +# user space programs
> +obj-$(CONFIG_SAMPLES) += seccomp/
> +obj-$(CONFIG_SAMPLES) += hidraw/
> 


-- 
~Randy
