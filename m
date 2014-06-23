Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaFWOTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:19:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:49302 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753883AbaFWOTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:19:19 -0400
Date: Mon, 23 Jun 2014 10:19:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Add missing mode to open() call
Message-ID: <20140623101917.49037713@gandalf.local.home>
In-Reply-To: <1403289749-1631-1-git-send-email-seth.forshee@canonical.com>
References: <1403289749-1631-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014 13:42:29 -0500
Seth Forshee <seth.forshee@canonical.com> wrote:

> touch_file() calls open(2) with O_CREAT but omits the required
> mode argument. Fix this omission.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Applied, thanks!

-- Steve

> ---
>  trace-record.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/trace-record.c b/trace-record.c
> index d3dd0c5..8438388 100644
> --- a/trace-record.c
> +++ b/trace-record.c
> @@ -1995,7 +1995,7 @@ static void touch_file(const char *file)
>  {
>  	int fd;
>  
> -	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC);
> +	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
>  	if (fd < 0)
>  		die("could not create file %s\n", file);
>  	close(fd);

