Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3ARV0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:26:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258Ab3ARV0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:26:32 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH V5 17/30] fs: use read_iter and write_iter rather than aio_read and aio_write
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
	<1357761525-22718-18-git-send-email-dave.kleikamp@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 18 Jan 2013 16:26:20 -0500
In-Reply-To: <1357761525-22718-18-git-send-email-dave.kleikamp@oracle.com>
	(Dave Kleikamp's message of "Wed, 9 Jan 2013 13:58:32 -0600")
Message-ID: <x497gnai3nn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp <dave.kleikamp@oracle.com> writes:

> @@ -1315,10 +1317,10 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb)
>  
>  	if ((iocb->ki_opcode == IOCB_CMD_PREADV) ||
>  		(iocb->ki_opcode == IOCB_CMD_PREAD)) {
> -		rw_op = file->f_op->aio_read;
> +		rw_op = do_aio_read;
>  		opcode = IOCB_CMD_PREADV;
>  	} else {
> -		rw_op = file->f_op->aio_write;
> +		rw_op = do_aio_read;
>  		opcode = IOCB_CMD_PWRITEV;
>  	}

That wants to be rw_op = do_aio_write in the else clause.  How did you
test this patch set?

Cheers,
Jeff
