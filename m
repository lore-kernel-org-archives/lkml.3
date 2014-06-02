Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaFBTSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:18:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:35975 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaFBTSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:18:47 -0400
Date: Mon, 2 Jun 2014 16:18:40 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf record: Fix poll return value propagation
Message-ID: <20140602191840.GI2544@kernel.org>
References: <1401732126-19465-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401732126-19465-1-git-send-email-jolsa@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 02, 2014 at 08:02:06PM +0200, Jiri Olsa escreveu:
> If the perf record command is interrupted in record__mmap_read_all
> function, the 'done' is set and err has the latest poll return
> value, which is most likely positive number (= number of pollfds
> ready to read).
> 
> This 'positive err' is then propagated to the exit code, resulting
> in not finishing the perf.data header properly, causing following
> error in report:
> 
>   # perf record -F 50000 -a

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
