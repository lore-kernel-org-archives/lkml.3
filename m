Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbbA2JKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:10:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758750AbbA2JJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:09:59 -0500
Date: Thu, 29 Jan 2015 10:09:41 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Wang Nan <wangnan0@huawei.com>, rostedt@goodmis.org
Cc: jeremie.galarneau@efficios.com, alexmonthy@voxpopuli.im,
        bigeasy@linutronix.de, lizefan@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] tools lib traceevent: add priv field to struct
 format_field.
Message-ID: <20150129090941.GF7781@krava.brq.redhat.com>
References: <1422268705-32084-1-git-send-email-wangnan0@huawei.com>
 <1422268705-32084-2-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422268705-32084-2-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 06:38:23PM +0800, Wang Nan wrote:
> Introduce a priv field to 'struct format_field' for futher expansion.
> 
> (In https://lkml.org/lkml/2015/1/21/383 , Jiri Olsa gives a suggestion
>  about changing lib traceevent to solve a bug of perf-convert-to-ctf,
>  which is related to duplicated field names. I think his suggestion
>  should be something like this patch. )

Hi Steven,
any feedback on this one?

thanks,
jirka

> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  tools/lib/traceevent/event-parse.c | 2 ++
>  tools/lib/traceevent/event-parse.h | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index cf3a44b..5f76003 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -5909,6 +5909,8 @@ static void free_format_fields(struct format_field *field)
>  		free(field->type);
>  		free(field->name);
>  		free(field);
> +		if (field->destroy_priv)
> +			field->destroy_priv(field);
>  		field = next;
>  	}
>  }
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index 7a3873f..928d801 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -190,6 +190,8 @@ struct format_field {
>  	unsigned int		arraylen;
>  	unsigned int		elementsize;
>  	unsigned long		flags;
> +	void			*priv;
> +	void 			(*destroy_priv)(struct format_field *);
>  };
>  
>  struct format {
> -- 
> 1.8.4
> 
