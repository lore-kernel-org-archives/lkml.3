Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbbAMBsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 20:48:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbbAMBsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 20:48:05 -0500
Date: Mon, 12 Jan 2015 22:47:57 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>, namhyung@kernel.org,
        peterz@infradead.org, jolsa@kernel.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-arch@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Borislav Petkov <bp@suse.de>, Cody P Schafer <dev@codyps.com>
Subject: Re: [PATCH v2 1/5] perf tools: [uclibc] fix statfs.f_type data type
 mismatch build error
Message-ID: <20150113014757.GG29743@kernel.org>
References: <1420888254-17504-1-git-send-email-vgupta@synopsys.com>
 <1420888254-17504-2-git-send-email-vgupta@synopsys.com>
 <20150112110522.GC26229@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112110522.GC26229@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 12, 2015 at 12:05:22PM +0100, Jiri Olsa escreveu:
> On Sat, Jan 10, 2015 at 04:40:50PM +0530, Vineet Gupta wrote:
> > From: Alexey Brodkin <abrodkin@synopsys.com>
> > 
> > ARC Linux uses the no legacy syscalls abi and corresponding uClibc headers
> > statfs defines f_type to be U32 which causes perf build breakage
> > 
> > http://git.uclibc.org/uClibc/tree/libc/sysdeps/linux/common-generic/bits/statfs.h
> > 
> > ----------->8---------------
> >   CC       fs/fs.o
> > fs/fs.c: In function 'fs__valid_mount':
> > fs/fs.c:82:24: error: comparison between signed and unsigned integer
> > expressions [-Werror=sign-compare]
> >   else if (st_fs.f_type != magic)
> >                         ^
> > cc1: all warnings being treated as errors
> > ----------->8---------------
> > 
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > Cc: Cody P Schafer <dev@codyps.com>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: linux-perf-users@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied, but please do not start lines in the changelog comment
with ---, that breaks some patch applying scripts. I fixed it up this
time.

- Arnaldo
