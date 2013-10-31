Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3JaRQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:16:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab3JaRQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:16:32 -0400
Date: Thu, 31 Oct 2013 18:18:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 3/4][v2] audit: move audit_aux_data_execve contents
	into audit_context union
Message-ID: <20131031171810.GA8757@redhat.com>
References: <cover.1383233533.git.rgb@redhat.com> <fe3109595c2dac17a55650b084a3c911f9e98597.1383233534.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe3109595c2dac17a55650b084a3c911f9e98597.1383233534.git.rgb@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31, Richard Guy Briggs wrote:
>
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -197,6 +197,10 @@ struct audit_context {
>  			int			fd;
>  			int			flags;
>  		} mmap;
> +		struct {
> +			int			argc;
> +			struct mm_struct	*mm;
> +		} execve;

Ah, nice, so we should not worry about kmalloc(GFP_KERNEL) failure.

I am in no position to ack the changes in this area, but the whole
series looks fine to me.

Oleg.

