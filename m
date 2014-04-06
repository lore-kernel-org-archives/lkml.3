Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaDFMUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 08:20:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbaDFMT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 08:19:58 -0400
Date: Sun, 6 Apr 2014 14:19:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com
Subject: Re: [PATCH 1/4] perf: Allow ability to map cpus to nodes easily
Message-ID: <20140406121952.GD1164@krava.brq.redhat.com>
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
 <1395689577-214654-2-git-send-email-dzickus@redhat.com>
 <20140329171033.GB2022@krava.redhat.com>
 <20140401023944.GQ25953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401023944.GQ25953@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 10:39:44PM -0400, Don Zickus wrote:
> On Sat, Mar 29, 2014 at 06:10:33PM +0100, Jiri Olsa wrote:
> > > +/* Determine highest possible node in the system for sparse allocation */
> > > +static void set_max_node_num(void)
> > > +{
> > > +	FILE *fp;
> > > +	int ret = -1;
> > > +
> > > +	/* set up default */
> > > +	max_node_num = 8;
> > > +
> > > +	/* get the highest possible cpu number for a sparse allocation */
> > > +	fp = fopen("/sys/devices/system/node/possible", "r");
> > > +	if (!fp)
> > > +		goto out;
> > 
> > any reason why not put fopen/fclose into __set_max_num ?
> 
> I either had to pass in a path string pointer or a file pointer, I just
> chose a file pointer.  Thought it fit with the rest of perf passing FPs
> around. :-D  It doesn't matter to me either way.

well, if there's no need to call it extra then the function can do it

jirka
