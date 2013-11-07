Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3KGNV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:21:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab3KGNV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:21:27 -0500
Date: Thu, 7 Nov 2013 14:21:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [PATCH 0/4] perf record: Cleanups and mmap-based output
Message-ID: <20131107132118.GD1251@krava.brq.redhat.com>
References: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 11:41:33AM -0700, David Ahern wrote:
> I know Jiri is working on cleanups of the output file, but had this
> sitting around for a couple of weeks now. Might as well push it out
> for the next baseline. The cleanups of perf-record can be taken
> independently.
> 
> Ingo: I took a look at leveraging the copy_user_nocache and was not able
>       to get it to work. I won't have time to come back to it for a while.
>       Given that the mmap output already improves perf-trace a lot I would
>       like to get the option into 3.13 and come back to the optimization
>       later.
> 
> David Ahern (4):
>   perf record: Refactor feature handling into a separate function
>   perf record: Remove advance_output function
>   perf record: Remove post_processing_offset variable
>   perf record: mmap output file - v3
> 
>  tools/perf/Documentation/perf-record.txt |   5 ++
>  tools/perf/builtin-record.c              | 137 ++++++++++++++++++++++++++-----
>  2 files changed, 123 insertions(+), 19 deletions(-)
> 

hi,
got this on F19:

  CC       builtin-record.o
builtin-record.c: In function ‘do_mmap_output’:
builtin-record.c:118:13: error: ignoring return value of ‘ftruncate’, declared with attribute warn_unused_result [-Werror=unused-result]
    ftruncate(file->fd, offset);
             ^
cc1: all warnings being treated as errors


jirka
