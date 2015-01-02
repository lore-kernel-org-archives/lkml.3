Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbbABPzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:55:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbbABPzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:55:44 -0500
Message-ID: <54A6BF7E.8070003@suse.cz>
Date: Fri, 02 Jan 2015 16:55:42 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sylvain BERTRAND <sylvain.bertrand@gmail.com>,
        linux-kbuild@vger.kernel.org
CC: linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [PATCH] scripts: fix link-vmlinux.sh bash-ism
References: <20141229163456.GB27533@dhcppc1>
In-Reply-To: <20141229163456.GB27533@dhcppc1>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-29 17:34, Sylvain BERTRAND wrote:
> Chocked while compiling linux with dash shell instead of bash shell.
> See:
> http://pubs.opengroup.org/onlinepubs/000095399/utilities/trap.html

Please describe the actual problem in the changelog. I guess it's
because of the 'ERR' trap?


> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
> ---
> --- a/scripts/link-vmlinux.sh	2014-12-29 15:10:29.436431249 +0000
> +++ b/scripts/link-vmlinux.sh	2014-12-29 16:23:06.010853608 +0000
> @@ -111,7 +111,6 @@
>  }
>  
>  # Delete output files in case of error
> -trap cleanup SIGHUP SIGINT SIGQUIT SIGTERM ERR
>  cleanup()
>  {
>  	rm -f .old_version
> @@ -124,6 +123,20 @@
>  	rm -f vmlinux.o
>  }
>  
> +on_exit()
> +{
> +	if [ $? -ne 0 ]; then
> +		cleanup
> +	fi
> +}
> +trap on_exit EXIT
> +
> +on_signals()
> +{
> +	exit 1
> +}
> +trap on_signals HUP INT QUIT TERM

Why not use 'cleanup' directly as a handler?

Michal
