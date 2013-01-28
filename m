Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab3A1MKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:10:44 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:33228 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab3A1MKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:10:40 -0500
Date: Mon, 28 Jan 2013 17:38:59 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] uprobes: Fix dentry/mount leak in
 create_trace_uprobe()
Message-ID: <20130128120859.GB29865@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130127194814.GA25377@redhat.com>
 <20130127194833.GA25395@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130127194833.GA25395@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012812-9574-0000-0000-0000065B4FFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-01-27 20:48:33]:

> create_trace_uprobe() does kern_path() to find ->d_inode, but forgets
> to do path_put(). We can do this right after igrab().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace_uprobe.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index f3fd8ff..53afabe 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -255,12 +255,13 @@ static int create_trace_uprobe(int argc, char **argv)
>  	if (ret)
>  		goto fail_address_parse;
> 
> +	inode = igrab(path.dentry->d_inode);
> +	path_put(&path);
> +
>  	ret = kstrtoul(arg, 0, &offset);
>  	if (ret)
>  		goto fail_address_parse;
> 
> -	inode = igrab(path.dentry->d_inode);
> -
>  	argc -= 2;
>  	argv += 2;
> 
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

