Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbbATNGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:06:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbbATNGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:06:44 -0500
Date: Tue, 20 Jan 2015 14:06:32 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Wang Nan <wangnan0@huawei.com>
Cc: jeremie.galarneau@efficios.com, bigeasy@linutronix.de, lizefan@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] perf: convert: two patches for converting syscall
 tracepoitns.
Message-ID: <20150120130632.GD15315@krava.brq.redhat.com>
References: <1421752029-64237-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421752029-64237-1-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 07:07:07PM +0800, Wang Nan wrote:
> This 2 patches are based on Jiri Olsa's perf repository:
> 
> https://git.kernel.org/cgit/linux/kernel/git/jolsa/perf.git/log/?h=perf/core_ctf_convert
> 
> Perf data convert to failes when converting perf.data recorded with
> 
>  # perf record -a -e syscalls:* sleep 1
> 
> The following 2 patches fix it.
> 
> Wang Nan (2):
>   perf: convert: fix duplicate field names.
>   perf: convert: fix signess of value.
> 
>  tools/perf/util/data-convert-bt.c | 101 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 96 insertions(+), 5 deletions(-)
> 
> -- 
> 1.8.4

hi,
also I've got following error:

  BUILD:   Doing 'make -j1' parallel build
  CC       util/data-convert-bt.o
util/data-convert-bt.c: In function ‘adjust_signess’:
util/data-convert-bt.c:170:6: error: unused variable ‘signbit’ [-Werror=unused-variable]
  int signbit;
      ^
util/data-convert-bt.c: In function ‘add_tracepoint_fields_types’:
util/data-convert-bt.c:668:30: error: unused variable ‘f’ [-Werror=unused-variable]
    struct bt_ctf_field_type *f;
                              ^
cc1: all warnings being treated as errors
make[1]: *** [util/data-convert-bt.o] Error 1
make: *** [all] Error 2


jirka
