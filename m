Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab3LBO6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:58:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab3LBO6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:58:03 -0500
Message-ID: <529C9FF7.3040005@suse.cz>
Date: Mon, 02 Dec 2013 15:57:59 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix detectition of kernel git repository in setlocalversion
 script
References: <1385990497-11805-1-git-send-email-fbuihuu@gmail.com>
In-Reply-To: <1385990497-11805-1-git-send-email-fbuihuu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.12.2013 14:21, Franck Bui-Huu wrote:
> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
> index 0b5ccf3..c16e65d 100755
> --- a/scripts/setlocalversion
> +++ b/scripts/setlocalversion
> @@ -43,7 +43,8 @@ scm_version()
>  	fi
>  
>  	# Check for git and a git repo.
> -	if test -d .git && head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
> +	if topdir=$(git rev-parse --show-cdup 2>/dev/null) && test -z "$topdir" &&
> +	   head=`git rev-parse --verify --short HEAD 2>/dev/null`; then

You can do test -z "$(git rev-parse --show-cdup 2>/dev/null)" without
the $topdir variable.

Michal
