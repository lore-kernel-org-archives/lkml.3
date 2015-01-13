Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbbAMEtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 23:49:53 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:46361 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbbAMEtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 23:49:50 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>
CC: "namhyung@kernel.org" <namhyung@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Alexey.Brodkin@synopsys.com" <Alexey.Brodkin@synopsys.com>,
        Borislav Petkov <bp@suse.de>, Cody P Schafer <dev@codyps.com>
Subject: Re: [PATCH v2 1/5] perf tools: [uclibc] fix statfs.f_type data type
 mismatch build error
Thread-Topic: [PATCH v2 1/5] perf tools: [uclibc] fix statfs.f_type data
 type mismatch build error
Thread-Index: AQHQLtMB+l91Mlgr4km5caF+7jcgbQ==
Date: Tue, 13 Jan 2015 04:49:42 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307565BCBBD6@IN01WEMBXA.internal.synopsys.com>
References: <1420888254-17504-1-git-send-email-vgupta@synopsys.com>
 <1420888254-17504-2-git-send-email-vgupta@synopsys.com>
 <20150112110522.GC26229@krava.redhat.com> <20150113014757.GG29743@kernel.org>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2015 07:18 AM, Arnaldo Carvalho de Melo wrote:

Em Mon, Jan 12, 2015 at 12:05:22PM +0100, Jiri Olsa escreveu:


> On Sat, Jan 10, 2015 at 04:40:50PM +0530, Vineet Gupta wrote:


> > From: Alexey Brodkin <abrodkin@synopsys.com><mailto:abrodkin@synopsys.com>
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
> > Cc: Borislav Petkov <bp@suse.de><mailto:bp@suse.de>
> > Cc: Jiri Olsa <jolsa@kernel.org><mailto:jolsa@kernel.org>
> > Cc: Cody P Schafer <dev@codyps.com><mailto:dev@codyps.com>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com><mailto:acme@redhat.com>
> > Cc: linux-perf-users@vger.kernel.org<mailto:linux-perf-users@vger.kernel.org>
> > Cc: linux-kernel@vger.kernel.org<mailto:linux-kernel@vger.kernel.org>
> > Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com><mailto:abrodkin@synopsys.com>


>
> Acked-by: Jiri Olsa <jolsa@kernel.org><mailto:jolsa@kernel.org>


Thanks, applied, but please do not start lines in the changelog comment
with ---, that breaks some patch applying scripts. I fixed it up this
time.

Thx. I've udpated the changelogs so scissor lines start at column 3 with leading whitespace, is that OK or do you want me to remove those lines altogether. Also do u want me to drop this patch from v3 of series as I have some fixups for other patches.

Thx,
-Vineet



- Arnaldo



