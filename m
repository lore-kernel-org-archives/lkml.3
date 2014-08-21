Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaHUHE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:04:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaHUHE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:04:57 -0400
Date: Thu, 21 Aug 2014 09:04:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, eranian@google.com,
        jmario@redhat.com
Subject: Re: [PATCH] perf: Fallback to MAP__FUNCTION if daddr maps are NULL
Message-ID: <20140821070451.GA1487@krava.brq.redhat.com>
References: <1408591511-57884-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408591511-57884-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 11:25:11PM -0400, Don Zickus wrote:
> As we run "perf c2c" on more applications, we noticed we're missing significant
> samples from a common customer's application.  Looking at the
> /proc/<pid>/maps file for the app, we see "rwxs" and "rwxp" permissions on many
> of the shared memory & heap regions, and on all the thread stacks.
> 
> Because those regions have the "x" bit set, perf marks them with a MAP_FUNCTION
> type.  Hence ip_resolve_data() never finds load or store events coming from
> them.
> 
> We fixed this by re-calling thread__find_addr_location with MAP__FUNCTION in
> the case where map is NULL as a last ditch effort to map the sample before
> giving up and dropping it.
> 
> Reported-by: Joe Mario <jmario@redhat.com>
> Tested-by: Joe Mario <jmario@redhat.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
