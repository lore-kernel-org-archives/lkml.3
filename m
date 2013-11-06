Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3KFMKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:10:55 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:41041 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab3KFMKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:10:52 -0500
Date: Wed, 6 Nov 2013 13:10:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
Message-ID: <20131106121038.GA7919@localhost.localdomain>
References: <87vc0c4ny2.fsf@sejong.aot.lge.com>
 <20131101075502.GA25547@gmail.com>
 <874n7w4gtm.fsf@sejong.aot.lge.com>
 <20131101092759.GC27063@gmail.com>
 <87bo1zz4mu.fsf@sejong.aot.lge.com>
 <20131105074650.GA2855@gmail.com>
 <87txfrxlq8.fsf@sejong.aot.lge.com>
 <20131105115802.GA12045@gmail.com>
 <87ppqex8tj.fsf@sejong.aot.lge.com>
 <20131106083046.GA4655@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106083046.GA4655@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 09:30:46AM +0100, Ingo Molnar wrote:
> 
> * Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > Hi Ingo,
> > 
> > On Tue, 5 Nov 2013 12:58:02 +0100, Ingo Molnar wrote:
> > > * Namhyung Kim <namhyung@kernel.org> wrote:
> > >> But the 'cumulative' (btw, I feel a bit hard to type this word..) is 
> > >> different in that it *generates* entries didn't get sampled originally. 
> > >> And as it requires callchains, total field will not work if callchains 
> > >> are missing.
> > >
> > > Well, 'total' should disappear if it's not available.
> > 
> > But what if it's the only sort key user gave?
> 
> Do you mean something like:
> 
>   -F self,name -s total
> 
> i.e. if a sort key not displayed?
> 
> I think sort keys should be automatically added to the displayed fields 
> list.
> 
> This rule is obviously met with the -F total:2,self:1,name:0 kind of 
> sorting syntax (you can only sort by fields that get displayed) - if mixed 
> with -s then it should be implicit I think.

I'm not sure why you want to add a new -F that adds news way to display fields.
Isn't -s enough for that?
