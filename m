Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925Ab3CMPtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:49:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656Ab3CMPtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:49:41 -0400
Date: Wed, 13 Mar 2013 12:49:29 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Make perf stat -I ... CSV output flat
Message-ID: <20130313154928.GA15763@infradead.org>
References: <1362624201-6161-1-git-send-email-andi@firstfloor.org>
 <CABPqkBT06EVjuy1ew1Z+vrGMf0p+mH19-M71xzTGVyZTtcaLUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBT06EVjuy1ew1Z+vrGMf0p+mH19-M71xzTGVyZTtcaLUA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 13, 2013 at 02:19:05PM +0100, Stephane Eranian escreveu:
> On Thu, Mar 7, 2013 at 3:43 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > +       if (interval && csv_output) {
> > +               fprintf(output, "time,,");
> 
> Don't quite understand the point of the ,,. By definition this
> extension is used for automatic
> post-processing. I cannot find a good justification for the
> double-comma, except for making

Yeah, that and the trailing comma as well, don't think they are needed.

> reading the output easy. But that's contradictory with the gnuplot goal.
> Also you need to add a # in front of this line to mark the line so it
> can be discarded (as comment)
> by any post-processing parser (such as gnuplot).
> 
> 
> Also I think something needs to be improved for the non-aggregated output
> in system-wide mode:
> 
> $ perf stat -I 10000 -x, -a -A -e cycles,instructions sleep 5
> 
> Don't you want events also grouped by CPU?
> 
> 
> Also noticed a bunch of trailing white spaces.

I fixed those in the updated patch I sent.
 
> I am not opposed to the idea of the patch, I think it is indeed useful
> for post-processing tools.

yeah
 
- Arnaldo
