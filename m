Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaC2RLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:11:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaC2RLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:11:10 -0400
Date: Sat, 29 Mar 2014 18:11:04 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com
Subject: Re: [PATCH 3/4] perf, callchain: Add generic report parse callchain
 callback function
Message-ID: <20140329171104.GD2022@krava.redhat.com>
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
 <1395689577-214654-4-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395689577-214654-4-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 03:32:56PM -0400, Don Zickus wrote:
> This takes the parse_callchain_opt function and copies it into the
> callchain.c file.  Now the c2c tool can use it too without duplicating.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  tools/perf/util/callchain.c | 83 +++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/callchain.h |  1 +
>  2 files changed, 84 insertions(+)
> 
> diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
> index 8d9db45..2320678 100644
> --- a/tools/perf/util/callchain.c
> +++ b/tools/perf/util/callchain.c
> @@ -25,6 +25,89 @@
>  
>  __thread struct callchain_cursor callchain_cursor;
>  
> +int
> +report_parse_callchain_opt(const char *arg)
> +{
> +	//struct report *rep = (struct report *)opt->value;

please erase ^^^

and I think it's better to merge this with the
actual removal in following patch:
    perf, report: Use new generic report parse callchain callback

jirka
