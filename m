Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab3AaHuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 02:50:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59810 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab3AaHuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 02:50:18 -0500
Date: Thu, 31 Jan 2013 07:50:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: chenggang.qin@gmail.com
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@alibaba-inc.com>
Subject: Re: [PATCH v3] Add 4 tracepoint events for vfs
Message-ID: <20130131075010.GM4503@ZenIV.linux.org.uk>
References: <y>
 <510a2020.654f420a.2872.7004@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510a2020.654f420a.2872.7004@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 03:40:38PM +0800, chenggang.qin@gmail.com wrote:
> @@ -1391,12 +1394,16 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
>  	unsigned long seg = 0;
>  	size_t count;
>  	loff_t *ppos = &iocb->ki_pos;
> +	const unsigned char *f_name;
>  
>  	count = 0;
>  	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
>  	if (retval)
>  		return retval;
>  
> +	f_name = filp->f_path.dentry->d_name.name;
> +	trace_generic_file_aio_read(pos, iov_length(iov, nr_segs), f_name);

And just what is going to prevent that f_name of yours from being freed
just as you are passing it to the function you are calling?

IOW, NAK.  BTW, I would like to point out that *ANY* hooks in VFS have all
the stability granted to driver API - removal fodder whenever it becomes
convenient.
