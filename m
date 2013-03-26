Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab3CZVfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:35:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab3CZVfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:35:33 -0400
Date: Tue, 26 Mar 2013 22:35:32 +0100
From: Michal Marek <mmarek@suse.cz>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/tags.sh: Add magic for OFFSET and DEFINE
Message-ID: <20130326213532.GB22359@pobox.suse.cz>
References: <1810321364036300@web2f.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1810321364036300@web2f.yandex.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 02:58:20PM +0400, Kirill Tkhai wrote:
> Add rules for definitions which is generally used in asm-offsets files.
> 
> Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
> CC: Michal Marek <mmarek@suse.cz>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  scripts/tags.sh |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 26a87e6..74f02e4 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -199,7 +199,9 @@ exuberant()
>  	--regex-c='/DEFINE_PER_CPU_SHARED_ALIGNED\(([^,]*,\s*)(\w*).*\)/\2/v/' \
>  	--regex-c='/DECLARE_WAIT_QUEUE_HEAD\((\w*)/\1/v/'		\
>  	--regex-c='/DECLARE_(TASKLET|WORK|DELAYED_WORK)\((\w*)/\2/v/'	\
> -	--regex-c='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'
> +	--regex-c='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'		\
> +	--regex-c='/(^\s)OFFSET\((\w*)/\2/v/'				\
> +	--regex-c='/(^\s)DEFINE\((\w*)/\2/v/'

The macro definitions in the asm-offsets.h file are ammended with a
comment explaining what the value actually means. So you see both the
value and the semantic of the macro:

#define TI_flags 16 /* offsetof(struct thread_info, flags)      # */


By jumping to the asm-offset.c file instead, you would get only a subset
of that information.

OFFSET(TI_flags, thread_info, flags);

Unless I'm missing something, I don't think that this patch improves
much.

Michal
