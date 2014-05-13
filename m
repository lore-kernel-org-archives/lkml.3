Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbaEMNIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:08:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834AbaEMNHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:07:42 -0400
Message-ID: <53721917.2090609@redhat.com>
Date: Tue, 13 May 2014 09:07:35 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>
CC: mmarek@suse.cz, akpm@linux-foundation.org,
        michael.opdenacker@free-electrons.com, tkhai@yandex.ru,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] scripts/tags.sh: add regular expression replacement
 pattern for memcg
References: <1399963400-7982-1-git-send-email-nasa4836@gmail.com>
In-Reply-To: <1399963400-7982-1-git-send-email-nasa4836@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/13/2014 02:43 AM, Jianyu Zhan wrote:
> Hi, Marek.
> 

Jianyu,

> Since previous one has got no replies. I resend it again.
> This patch purely add regex pattern only. And I've tested it, it works.
> 
> ---<8---
> Currently, no regular expression replacement pattern for PageCgroug*

^^^ *Cgroup*

> defined, which causes quite a few pain while reading code. Just get
> rid of it.
> 

IMO the patch looks fine but can you fixup your changelog a little bit?  I think
the new "standard" has become an explanation and example of the problem, an
explanation of what is wrong, and what you did to fix it (including an example
of output if possible).  That way we know what was changed and why :)

P.

> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  scripts/tags.sh | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index f2c5b00..7d3ebfe 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -187,6 +187,10 @@ exuberant()
>  	--regex-c++='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
>  	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
>  	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'		\
> +	--regex-c++='/TESTPCGFLAG\(([^,)]*).*/PageCgroup\1/'		\
> +	--regex-c++='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'		\
> +	--regex-c++='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
> +	--regex-c++='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
>  	--regex-c='/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/' \
>  	--regex-c='/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/' \
>  	--regex-c='/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'	\
> @@ -244,6 +248,10 @@ emacs()
>  	--regex='/__CLEARPAGEFLAG_NOOP(\([^,)]*\).*/__ClearPage\1/' \
>  	--regex='/TESTCLEARFLAG_FALSE(\([^,)]*\).*/TestClearPage\1/' \
>  	--regex='/__TESTCLEARFLAG_FALSE(\([^,)]*\).*/__TestClearPage\1/' \
> +	--regex='/TESTPCGFLAG\(([^,)]*).*/PageCgroup\1/'	\
> +	--regex='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'	\
> +	--regex='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
> +	--regex='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
>  	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'		\
>  	--regex='/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/' \
>  	--regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/'
> 
