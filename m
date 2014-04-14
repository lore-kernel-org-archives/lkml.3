Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaDNKP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:15:27 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61754 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaDNKPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:15:23 -0400
MIME-Version: 1.0
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 14 Apr 2014 12:15:01 +0200
X-Google-Sender-Auth: -W5qRTl4uV_P8YWCKjMToywDllY
Message-ID: <CAHO5Pa0VCzR7oqNXkwELuAsNQnnvF8Xoo=CuCaM64-GzjDuoFA@mail.gmail.com>
Subject: Documenting prctl() PR_SET_THP_DISABLE and PR_GET_THP_DISABLE
To: Alex Thorlton <athorlton@sgi.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>,
        linux-man@vger.kernel.org,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

Your commit a0715cc22601e8830ace98366c0c2bd8da52af52 added the prctl()
PR_SET_THP_DISABLE and PR_GET_THP_DISABLE flags.

The text below attempts to document these flags for the prctl(3).
Could you (and anyone else who is willing) please review the text
below (one or two p[ieces of which are drawn from your commit message)
to verify that it accurately reflects reality and your intent, and
that I have not missed any significant details.

    DESCRIPTION
    ...
       PR_SET_THP_DISABLE (since Linux 3.15)
              Set the state of the "THP disable" flag for the  calling
              thread.   If  arg2 has a nonzero value, the flag is set,
              otherwise it is cleared.  Setting this flag  provides  a
              method  for disabling  transparent  huge  pages for jobs
              where the code cannot be modified, and  using  a  malloc
              hook  with madvise(2) is not an option (i.e., statically
              allocated data).  The setting of the "THP disable"  flag
              is  inherited by a child created via fork(2) and is pre‐
              served across execve(2).

       PR_GET_THP_DISABLE (since Linux 3.15)
              Return (via the function result) the current setting  of
              the "THP disable" flag for the calling thread: either 1,
              if the flag is set, or 0, if it is not.
    ...
    RETURN VALUE
       On       success,       PR_GET_DUMPABLE,       PR_GET_KEEPCAPS,
       PR_GET_NO_NEW_PRIVS,    PR_GET_THP_DISABLE,    PR_CAPBSET_READ,
       PR_GET_TIMING,       PR_GET_TIMERSLACK,      PR_GET_SECUREBITS,
       PR_MCE_KILL_GET, and (if it returns) PR_GET_SECCOMP return  the
       nonnegative  values  described  above.  All other option values
       return 0 on success.  On error, -1 is returned,  and  errno  is
       set appropriately.
    ...
    ERRORS
       EINVAL option is PR_SET_THP_DISABLE and arg3, arg4, or arg5  is
              nonzero.

       EINVAL option  is  PR_GET_THP_DISABLE  and arg2, arg3, arg4, or
              arg5 is nonzero.

Thanks,

Michael



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
