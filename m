Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaL3P32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:29:28 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52234 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaL3P30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:29:26 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18D2MW9th1ce0+DBLJCXFpvMjEJ5/CHzAo=
X-DKIM: OpenDKIM Filter v2.0.1 titan 88DC963A1B8
Date: Tue, 30 Dec 2014 10:29:23 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: mathieu.poirier@linaro.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] staging: skein: Fixing various coding style
 problems
Message-ID: <20141230152923.GN28117@titan.lakedaemon.net>
References: <1419261639-17157-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419261639-17157-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu,

On Mon, Dec 22, 2014 at 08:20:37AM -0700, mathieu.poirier@linaro.org wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> This patchset is fixing miscellaneous coding style problems as reported
> by checkpatch.  More interesting is the removal of 'do {} while (0) loop'
> statements for single line macros.  The following provides a guarantee the
> semantic of the object code hasn't been altered by the rectification:
> 
> mpoirier@t430:~/work/kernel1$
> 146320048532 staging: skein: Fixing single statement macro checkpatch warning
> ef68ffa9fd3e staging: skein: Fixing trailing whitespace error
> 97bf6af1f928 Linux 3.19-rc1
> mpoirier@t430:~/work/kernel1$ git reset --hard 97bf6af1f928
> HEAD is now at 97bf6af1f928 Linux 3.19-rc1
> mpoirier@t430:~/work/kernel1$ make drivers/staging/skein/skein_block.o
>   CHK     include/config/kernel.release
>   UPD     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   UPD     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CC      drivers/staging/skein/skein_block.o
> mpoirier@t430:~/work/kernel1$ ./scripts/objdiff record drivers/staging/skein/skein_block.o
> mpoirier@t430:~/work/kernel1$ git reset --hard 146320048532
> HEAD is now at 146320048532 staging: skein: Fixing single statement macro checkpatch warning
> mpoirier@t430:~/work/kernel1$ make drivers/staging/skein/skein_block.o
>   CHK     include/config/kernel.release
>   UPD     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   UPD     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CC      drivers/staging/skein/skein_block.o
> mpoirier@t430:~/work/kernel1$ ./scripts/objdiff record drivers/staging/skein/skein_block.o
> mpoirier@t430:~/work/kernel1$ ./scripts/objdiff diff 97bf6af1f928 146320048532
> mpoirier@t430:~/work/kernel1$
> 
> New to this patchset:
> . Introduction of a cover letter that includes a scripts/objdiff snapshot
> . Splitting of the change set by semantic
> 
> Mathieu Poirier (2):
>   staging: skein: Fixing trailing whitespace error
>   staging: skein: Fixing single statement macro checkpatch warning
> 
>  drivers/staging/skein/skein_block.c   | 17 ++++-------------
>  drivers/staging/skein/skein_generic.c |  1 -
>  2 files changed, 4 insertions(+), 14 deletions(-)

Awesome!  For the whole series,

Acked-by:  Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
