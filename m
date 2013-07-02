Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3GBRui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:50:38 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:60375 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3GBRug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:50:36 -0400
Message-ID: <51D312E8.6090702@gmail.com>
Date: Tue, 02 Jul 2013 13:50:32 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Yann Droneaud <ydroneaud@opteya.com>
CC: linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 12/13] sctp: use get_unused_fd_flags(0) instead of get_unused_fd()
References: <cover.1372777600.git.ydroneaud@opteya.com> <6d4271e2e0b05ae2728cba1d890e77cac50cf8f0.1372777600.git.ydroneaud@opteya.com>
In-Reply-To: <6d4271e2e0b05ae2728cba1d890e77cac50cf8f0.1372777600.git.ydroneaud@opteya.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 12:39 PM, Yann Droneaud wrote:
> Macro get_unused_fd() is used to allocate a file descriptor with
> default flags. Those default flags (0) can be "unsafe":
> O_CLOEXEC must be used by default to not leak file descriptor
> across exec().
>
> Instead of macro get_unused_fd(), functions anon_inode_getfd()
> or get_unused_fd_flags() should be used with flags given by userspace.
> If not possible, flags should be set to O_CLOEXEC to provide userspace
> with a default safe behavor.
>
> In a further patch, get_unused_fd() will be removed so that
> new code start using anon_inode_getfd() or get_unused_fd_flags()
> with correct flags.
>
> This patch replaces calls to get_unused_fd() with equivalent call to
> get_unused_fd_flags(0) to preserve current behavor for existing code.
>
> The hard coded flag value (0) should be reviewed on a per-subsystem basis,
> and, if possible, set to O_CLOEXEC.
>
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad

> ---
>   net/sctp/socket.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 66fcdcf..caa5919 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -4320,7 +4320,7 @@ static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval
>   		goto out;
>
>   	/* Map the socket to an unused fd that can be returned to the user.  */
> -	retval = get_unused_fd();
> +	retval = get_unused_fd_flags(0);
>   	if (retval < 0) {
>   		sock_release(newsock);
>   		goto out;
>

