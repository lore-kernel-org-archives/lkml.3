Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030984AbaDJNZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:25:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030617AbaDJNZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:25:09 -0400
Date: Thu, 10 Apr 2014 15:24:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        namhyung@gmail.com
Subject: Re: [PATCH 1/4 v2] perf: Allow ability to map cpus to nodes easily
Message-ID: <20140410132458.GB13001@krava.brq.redhat.com>
References: <1396896924-129847-1-git-send-email-dzickus@redhat.com>
 <1396896924-129847-2-git-send-email-dzickus@redhat.com>
 <20140410093146.GE1141@krava.brq.redhat.com>
 <20140410131515.GF8488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410131515.GF8488@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 09:15:15AM -0400, Don Zickus wrote:
> On Thu, Apr 10, 2014 at 11:31:46AM +0200, Jiri Olsa wrote:
> > On Mon, Apr 07, 2014 at 02:55:21PM -0400, Don Zickus wrote:
> > 
> > SNIP
> > 
> > > +static int init_cpunode_map(void)
> > > +{
> > > +	int i;
> > > +
> > > +	set_max_cpu_num();
> > > +	set_max_node_num();
> > > +
> > > +	cpunode_map = calloc(max_cpu_num, sizeof(int));
> > > +	if (!cpunode_map) {
> > > +		pr_err("%s: calloc failed\n", __func__);
> > > +		goto out;
> > shuld probably be ^^^:
> > 
> > 		return -1;
> > 
> > > +	}
> > > +
> > > +	for (i = 0; i < max_cpu_num; i++)
> > > +		cpunode_map[i] = -1;
> > > +
> > > +	return 0;
> > > +out:
> > > +	return -1;
> > 
> > and remove 'out' label code
> 
> Sorry, probably leftover code that after snipping and changing didn't get
> noticed.  Thanks.
> 
> > 
> > other than that, it seems ok.. I'll queue it
> 
> I assume you are making the changes locally or should I resubmit?

yes, I'll do that localy

jirka
