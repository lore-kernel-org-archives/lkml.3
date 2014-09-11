Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbaIKPAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:00:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaIKPAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:00:10 -0400
Date: Thu, 11 Sep 2014 16:59:45 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 13/14] tools lib fd array: Allow associating an integer
 cookie with each entry
Message-ID: <20140911145945.GC32722@krava.brq.redhat.com>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <1410358129-9965-14-git-send-email-acme@kernel.org>
 <20140911103319.GA13634@krava.brq.redhat.com>
 <20140911132911.GB10158@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911132911.GB10158@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 10:29:11AM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

> > I like the idea of private pointer for each fd, but I think it should
> > be 'void*' to keep the library generic. The 'int*' is related only to
> > the evlist usage of this.
> 
> Right, from the changelog comment for this patch:
> 
> ------------------------------
>     We may need to have further info associated with each fdarray entry,
> in that case we'll make that int array a 'union fdarray_priv' one and
> put a pointer there so that users can stash whatever they want there.
> For now, an int is enough tho.
> ------------------------------
> 
> I had it as:
> 
> 	struct fdarray {
> 	...
> 		union {
> 			int 	idx;
> 			void	*ptr;
> 		} priv;
> 	...
> 	}
> 
> But then I had no use whatsoever for the ->ptr one at this point, so I
> just nuked it, to keep _just_ what is used _right now_, and added the
> comment to the changelog :-)

if we are treeting tools/lib/api as 'external' lib, I think we should
use 'void *' for priv and let the user retype it to whatever he wants

but I dont care/insist here too much.. it just seems strange to me ;-)

jirka
