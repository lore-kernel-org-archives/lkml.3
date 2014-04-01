Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaDACju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 22:39:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaDACjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 22:39:49 -0400
Date: Mon, 31 Mar 2014 22:39:44 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com
Subject: Re: [PATCH 1/4] perf: Allow ability to map cpus to nodes easily
Message-ID: <20140401023944.GQ25953@redhat.com>
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
 <1395689577-214654-2-git-send-email-dzickus@redhat.com>
 <20140329171033.GB2022@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140329171033.GB2022@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 06:10:33PM +0100, Jiri Olsa wrote:
> > +/* Determine highest possible node in the system for sparse allocation */
> > +static void set_max_node_num(void)
> > +{
> > +	FILE *fp;
> > +	int ret = -1;
> > +
> > +	/* set up default */
> > +	max_node_num = 8;
> > +
> > +	/* get the highest possible cpu number for a sparse allocation */
> > +	fp = fopen("/sys/devices/system/node/possible", "r");
> > +	if (!fp)
> > +		goto out;
> 
> any reason why not put fopen/fclose into __set_max_num ?

I either had to pass in a path string pointer or a file pointer, I just
chose a file pointer.  Thought it fit with the rest of perf passing FPs
around. :-D  It doesn't matter to me either way.

> 
> also looks like 'get_max_num' would fit better for __set_max_num ;-)

Yeah, I split it out based on your suggestion and didn't realize the
details kinda changed.

Cheers,
Don

