Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab3BUSUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:20:09 -0500
Received: from plane.gmane.org ([80.91.229.3]:47960 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391Ab3BUSUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:20:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Namhyung Kim <namhyung@kernel.org>
Subject: Re: [perf patch] perf doesn't delete /tmp/perf-vdso.so.* file on exit
Date: Thu, 21 Feb 2013 18:19:52 +0000 (UTC)
Message-ID: <loom.20130221T191341-303@post.gmane.org>
References: <20130221094544.GA2919@x4> <20130221102748.GB2919@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 69.38.217.222 (Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20100101 Firefox/18.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Trippelsdorf <markus <at> trippelsdorf.de> writes:
> 
> perf top doesn't unlink /tmp/perf-vdso.so.* on exit.
> Fix this by calling vdso__exit() before exit(0).

> @@ -602,6 +603,7 @@ static void *display_thread_tui(void *arg)
>  				      &top->session->header.env);
> 
>  	exit_browser(0);
> +	vdso__exit();
>  	exit(0);
>  	return NULL;
>  }

I don't think it's enough - it doesn't cover all exit paths.
I'd suggest making it to use atexit/on_exit().

Thanks,
Namhyung



