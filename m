Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934376AbaJ2Pps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:45:48 -0400
Received: from app1b.xlhost.de ([84.200.252.162]:44055 "EHLO app1b.xlhost.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933673AbaJ2Ppq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:45:46 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2014 11:45:45 EDT
Message-ID: <5451099B.7090102@kpanic.de>
Date: Wed, 29 Oct 2014 16:36:59 +0100
From: Stefan Assmann <sassmann@kpanic.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org
CC: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v2 4/4] backports: add kernl integration support to gentree.py
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com> <1414570902-5675-5-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1414570902-5675-5-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.10.2014 09:21, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  backport/Kconfig                              |  54 --------
>  backport/Kconfig.sources                      |  23 ++++
>  backport/Makefile                             |   3 +-
>  backport/Makefile.kernel                      |  18 +++
>  backport/backport-include/backport/backport.h |   2 +
>  backport/compat/Makefile                      |   4 +
>  gentree.py                                    | 186 +++++++++++++++++++++-----
>  lib/bpversion.py                              |  48 +++++++
>  lib/kconfig.py                                |  12 +-
>  9 files changed, 260 insertions(+), 90 deletions(-)
>  delete mode 100644 backport/Kconfig
>  create mode 100644 backport/Kconfig.sources
>  create mode 100644 lib/bpversion.py

This breaks my usual gentree.py run.

~/backports> ./gentree.py --clean --git-revision next-20141023 ~/backports/linux-next/ /dev/shm/backports-next
Get original source files from git ...
Traceback (most recent call last):
  File "./gentree.py", line 1028, in <module>
    ret = _main()
  File "./gentree.py", line 517, in _main
    logwrite=logwrite)
  File "./gentree.py", line 637, in process
    copy_files(os.path.join(source_dir, 'backport'), backport_files, args.outdir)
  File "./gentree.py", line 175, in copy_files
    os.path.join(outdir, tgtitem))
  File "/usr/lib64/python2.7/shutil.py", line 119, in copy
    copyfile(src, dst)
  File "/usr/lib64/python2.7/shutil.py", line 82, in copyfile
    with open(src, 'rb') as fsrc:
IOError: [Errno 2] No such file or directory: '/root/backports/backport/Kconfig.package'

I don't see Kconfig.package in this series. Did you forget to git add it?

  Stefan
