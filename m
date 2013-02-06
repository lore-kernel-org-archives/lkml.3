Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab3BFJ4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:56:16 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:40941 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab3BFJ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:56:13 -0500
MIME-Version: 1.0
Reply-To: hanwen@xs4all.nl
In-Reply-To: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Date: Wed, 6 Feb 2013 10:56:11 +0100
Message-ID: <CAOw_e7bgPLMzvTGczFH+npo+usrSOkHHRrpAGc-3GndVH0uuFw@mail.gmail.com>
Subject: Re: [fuse-devel] [PATCH] fuse: make fuse daemon frozen along with
 kernel threads
From: Han-Wen Nienhuys <hanwenn@gmail.com>
To: Li Fei <fei.li@intel.com>
Cc: miklos@szeredi.hu, pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com,
        mingo@redhat.com, peterz@infradead.org, biao.wang@intel.com,
        linux-pm@vger.kernel.org, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 2:11 AM, Li Fei <fei.li@intel.com> wrote:
>
> There is well known issue that freezing will fail in case that fuse
> daemon is frozen firstly with some requests not handled, as the fuse
> usage task is waiting for the response from fuse daemon and can't be
> frozen.
>
> To solve the issue above, make fuse daemon frozen after all all user
> space processes frozen and during the kernel threads frozen phase.
> PF_FREEZE_DAEMON flag is added to indicate that the current thread is
> the fuse daemon, set on connection, and clear on disconnection.
> It works as all fuse requests are handled during user space processes
> frozen, there will no further fuse request, and it's safe to continue
> to freeze fuse daemon together with kernel freezable tasks.

Will this work correctly if one FUSE daemon is opening files in from
another FUSE filesystem?

-- 
Han-Wen Nienhuys - hanwen@xs4all.nl - http://www.xs4all.nl/~hanwen
