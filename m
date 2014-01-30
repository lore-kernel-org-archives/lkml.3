Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaA3VtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:49:05 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:60487 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbaA3VtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:49:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-afs@lists.infradead.org,
        Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
References: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
Date: Thu, 30 Jan 2014 13:48:48 -0800
In-Reply-To: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk> (David
	Howells's message of "Sun, 26 Jan 2014 12:27:29 +0000")
Message-ID: <8761p1m98f.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX19SaNpQT6RSeUBsVMXquv6OoHm1X6yU4R8=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0203]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Howells <dhowells@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> From: Pali Rohár <pali.rohar@gmail.com>
>
> Both proc files are writeable and used for configuring cells. But
> there is missing correct mode flag for writeable files. Without
> this patch both proc files are read only.

Dumb question.  Is this worth fixing?  Should we perhaps instead remove
the write methods?

These files have been read-only since this code was merged in 2002.
Over a decade of not being used seems like a strong indication that no
one cares about the write path.

Eric

> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  fs/afs/proc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/afs/proc.c b/fs/afs/proc.c
> index 526e4bbbde59..276cb6ed0b93 100644
> --- a/fs/afs/proc.c
> +++ b/fs/afs/proc.c
> @@ -147,11 +147,11 @@ int afs_proc_init(void)
>  	if (!proc_afs)
>  		goto error_dir;
>  
> -	p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
> +	p = proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_cells_fops);
>  	if (!p)
>  		goto error_cells;
>  
> -	p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
> +	p = proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_rootcell_fops);
>  	if (!p)
>  		goto error_rootcell;
>  
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
