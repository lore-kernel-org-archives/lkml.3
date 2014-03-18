Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaCRNaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:30:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:22193 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754380AbaCRNaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:30:15 -0400
Date: Tue, 18 Mar 2014 09:30:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 3/5] tools lib traceevent: use else-if cascade, not
 separate ifs
Message-ID: <20140318093006.16517a08@gandalf.local.home>
In-Reply-To: <20140318131048.GA3585@infradead.org>
References: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
	<1395095198-20034-4-git-send-email-artagnon@gmail.com>
	<87d2hkrl32.fsf@sejong.aot.lge.com>
	<20140318131048.GA3585@infradead.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 10:10:48 -0300
Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Tue, Mar 18, 2014 at 05:02:09PM +0900, Namhyung Kim escreveu:
> > On Mon, 17 Mar 2014 18:26:36 -0400, Ramkumar Ramachandra wrote:
> > > When token cannot be more than one value, it seems wasteful to go
> > > through all the strcmp() calls. Use an else-if cascade instead.
> > 
> > I think the end result will be same since it returns from inside the
> > block, right?
> 
> Exactly :-)
> 
> We could have it changed to something like:
> 
> 	if (strcmp()) {
> 		ret = bla();
> 		goto out_free_token;
> 	}
> .
> .
> .
> out_free_token:
> 	free_token(token);
> 	return ret;
> 
>  

Honestly, I prefer the original, thus I would add a NAK to this patch.

-- Steve
