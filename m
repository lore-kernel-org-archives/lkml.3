Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934663AbaFTHQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:16:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbaFTHQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:16:06 -0400
Date: Fri, 20 Jun 2014 09:15:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 00/18] perf tools: Factor ordered samples queue
Message-ID: <20140620071549.GA1218@krava.brq.redhat.com>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
 <53A1EC2E.1010706@gmail.com>
 <20140619103448.GA7619@krava.brq.redhat.com>
 <53A323E0.8040307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A323E0.8040307@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 11:54:40AM -0600, David Ahern wrote:
> On 6/19/14, 4:34 AM, Jiri Olsa wrote:
> >>I've skimmed through the patches. What happens if you are in the middle of a
> >>round and the max queue size is reached?
> >
> >half of the queue (time half) is flushed to make some free space
> 
> right, I believe there will be scenarios where that will cause failures with
> out of order timestamps.

yep, but I did not hit any so far.. thats why I added
patch 18 - not to drop out of seq. event if it's found
after this flush

jirka
