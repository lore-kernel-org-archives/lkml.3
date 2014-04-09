Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbaDINKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:10:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758279AbaDINJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:09:38 -0400
Date: Wed, 9 Apr 2014 15:09:34 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf stat: Don't print bogus data when one event is
 requested
Message-ID: <20140409130934.GC2556@krava.brq.redhat.com>
References: <1395958859-14490-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395958859-14490-1-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 06:20:59PM -0400, Ramkumar Ramachandra wrote:
> When only the stalled-cycles-frontend event is requested:
> 
>   $ perf stat -e stalled-cycles-frontend -- git s
>   ## acme...ram/acme
> 
>    Performance counter stats for 'git s':
> 
>          326,947,423      stalled-cycles-frontend   #    0.00% frontend cycles idle
> 
>          0.363599976 seconds time elapsed
> 
> The 0.00% frontend cycles idle comment in the output is totally bogus
> and misleading. Omit printing it here, as well as in the
> stalled-cycles-backend case.

hi,
I agree with the change, but the reason for 0% is not only that
'one' event was stated, but that 'cycles' event is missing in
measurement.

Please change your changelog accordingly, the change itself
looks ok.

thanks,
jirka
