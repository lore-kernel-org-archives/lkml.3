Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaJVQ6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:58:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbaJVQ6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:58:53 -0400
Date: Wed, 22 Oct 2014 18:55:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] coredump: fix incomplete core file created when
	dump_skip was used last
Message-ID: <20141022165530.GA30358@redhat.com>
References: <1413932228-27642-1-git-send-email-victor.kamensky@linaro.org> <1413932228-27642-2-git-send-email-victor.kamensky@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413932228-27642-2-git-send-email-victor.kamensky@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21, Victor Kamensky wrote:
>
> +static int dump_write_last_byte(struct coredump_params *cprm)
> +{
> +	char lastbyte = 0;
> +	struct file *file = cprm->file;
> +
> +	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
> +		if (dump_interrupted() ||
> +		    file->f_op->llseek(file, -1, SEEK_CUR) < 0)
> +			return 0;
> +		if (!dump_emit(cprm, &lastbyte, 1))
> +			return 0;
> +	}
> +	return 1;
> +}

Perhaps do_truncate(cprm.file->f_path.dentry, ->f_pos) makes more sense?

and unless I missed something cprm->last_op_status can be avoided, we can
simply check f_pos != i_size_read() at the end?

Oleg.

