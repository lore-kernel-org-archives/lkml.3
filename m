Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbaCESvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:51:03 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:36838 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbaCESvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:51:00 -0500
Date: Wed, 5 Mar 2014 19:50:47 +0100
From: Guillaume Morin <guillaume@morinfr.org>
To: Colin King <colin.king@canonical.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: ipc: handle msgget failure return correctly
Message-ID: <20140305185046.GA6708@bender.morinfr.org>
Mail-Followup-To: Colin King <colin.king@canonical.com>,
	Stanislav Kinsbursky <skinsbursky@parallels.com>,
	linux-kernel@vger.kernel.org
References: <1394041873-4220-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394041873-4220-1-git-send-email-colin.king@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05 Mar 17:51, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> A failed msgget causes the test to return an uninitialised value
> in ret. Assign ret to -errno on error exit.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  tools/testing/selftests/ipc/msgque.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
> index d664182..be8f294 100644
> --- a/tools/testing/selftests/ipc/msgque.c
> +++ b/tools/testing/selftests/ipc/msgque.c
> @@ -202,6 +202,7 @@ int main(int argc, char **argv)
>  	msgque.msq_id = msgget(msgque.key, IPC_CREAT | IPC_EXCL | 0666);
>  	if (msgque.msq_id == -1) {
>  		printf("Can't create queue\n");
> +		err = -errno;
>  		goto err_out;
>  	}
>  
> -- 

Maybe I am nitpicking here but printf() could modify errno, so you might
as well save it before printf() is called.

-- 
Guillaume Morin <guillaume@morinfr.org>
