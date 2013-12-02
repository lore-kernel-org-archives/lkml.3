Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab3LBUN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:13:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab3LBUJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:09:05 -0500
Date: Mon, 2 Dec 2013 15:09:01 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH 3.10 086/173] audit: log the audit_names record type
Message-ID: <20131202150901.24a0ee87@tlielax.poochiereds.net>
In-Reply-To: <20131202191153.440613725@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
	<20131202191153.440613725@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Dec 2013 11:11:09 -0800
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> 3.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jeff Layton <jlayton@redhat.com>
> 
> commit d3aea84a4ace5ff9ce7fb7714cee07bebef681c2 upstream.
> 
> ...to make it clear what the intent behind each record's operation was.
> 
> In many cases you can infer this, based on the context of the syscall
> and the result. In other cases it's not so obvious. For instance, in
> the case where you have a file being renamed over another, you'll have
> two different records with the same filename but different inode info.
> By logging this information we can clearly tell which one was created
> and which was deleted.
> 
> This fixes what was broken in commit bfcec708.
> Commit 79f6530c should also be backported to stable v3.7+.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  kernel/audit.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1537,6 +1537,26 @@ void audit_log_name(struct audit_context
>  		}
>  	}
>  
> +	/* log the audit_names record type */
> +	audit_log_format(ab, " nametype=");
> +	switch(n->type) {
> +	case AUDIT_TYPE_NORMAL:
> +		audit_log_format(ab, "NORMAL");
> +		break;
> +	case AUDIT_TYPE_PARENT:
> +		audit_log_format(ab, "PARENT");
> +		break;
> +	case AUDIT_TYPE_CHILD_DELETE:
> +		audit_log_format(ab, "DELETE");
> +		break;
> +	case AUDIT_TYPE_CHILD_CREATE:
> +		audit_log_format(ab, "CREATE");
> +		break;
> +	default:
> +		audit_log_format(ab, "UNKNOWN");
> +		break;
> +	}
> +
>  	audit_log_fcaps(ab, n);
>  	audit_log_end(ab);
>  }
> 
> 

I'm not sure this is really suitable or needed for stable. It's
unlikely to hurt anything, but it doesn't really fix a problem per-se.
It just adds a little extra info to the audit records.

Ditto for the 3.12 version of this patch...

-- 
Jeff Layton <jlayton@redhat.com>
