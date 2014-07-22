Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaGVHzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:55:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbaGVHzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:55:46 -0400
Date: Tue, 22 Jul 2014 09:55:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] perf tools: Record whether a dso has data
Message-ID: <20140722075515.GB29305@krava.redhat.com>
References: <1405586590-13657-3-git-send-email-adrian.hunter@intel.com>
 <1405587510-15037-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405587510-15037-1-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 11:58:30AM +0300, Adrian Hunter wrote:
> Add 'data_status' to record whether a dso has data
> (i.e. an object file)

I might have seen it in your last patsent, but forgot.. what is
this data_status going to be used for?

SNIP

> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
> index c239e86..07d0a58 100644
> --- a/tools/perf/util/dso.h
> +++ b/tools/perf/util/dso.h
> @@ -40,6 +40,12 @@ enum dso_swap_type {
>  	DSO_SWAP__YES,
>  };
>  
> +enum dso_data_status {
> +	DSO_DATA_STATUS_ERROR	= -1,
> +	DSO_DATA_STATUS_UNKNOWN	= 0,
> +	DSO_DATA_STATUS_OK	= 1,
> +};
> +
>  #define DSO__SWAP(dso, type, val)			\
>  ({							\
>  	type ____r = val;				\
> @@ -104,6 +110,7 @@ struct dso {
>  	struct {
>  		struct rb_root	 cache;
>  		int		 fd;
> +		int		 data_status;

also please call it just 'status' it's already in 'data' struct

thanks,
jirka
