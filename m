Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbaD2INF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:13:05 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:53085 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbaD2INC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:13:02 -0400
Date: Tue, 29 Apr 2014 10:12:57 +0200
From: Robert Richter <rric@kernel.org>
To: Masanari Iida <standby24x7@gmail.com>
Cc: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oprofile: Fix format string mismatch in oprofile_perf.c
Message-ID: <20140429081257.GH32718@rric.localhost>
References: <1398730940-2151-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398730940-2151-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.04.14 09:22:20, Masanari Iida wrote:
> Fix format string mismatch in oprofile_perf_create_files.

Please provide a compiler warning.

> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/oprofile/oprofile_perf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
> index d5b2732..968e6dc 100644
> --- a/drivers/oprofile/oprofile_perf.c
> +++ b/drivers/oprofile/oprofile_perf.c
> @@ -146,7 +146,7 @@ static int oprofile_perf_create_files(struct dentry *root)

        unsigned int i;

        for (i = 0; i < num_counters; i++) {

>  		struct dentry *dir;
>  		char buf[4];
>  
> -		snprintf(buf, sizeof buf, "%d", i);
> +		snprintf(buf, sizeof buf, "%u", i);

Since num_counters is int we better fix this by changing the i
declaration to int which avoids comparing unsigned/signed.

-Robert

>  		dir = oprofilefs_mkdir(root, buf);
>  		oprofilefs_create_ulong(dir, "enabled", &counter_config[i].enabled);
>  		oprofilefs_create_ulong(dir, "event", &counter_config[i].event);
> -- 
> 2.0.0.rc1
> 
