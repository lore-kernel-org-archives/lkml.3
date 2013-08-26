Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3HZOh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:37:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28705 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3HZOh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:37:27 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=WWWfXbpW1U4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=G5Vss12qNGkA:10 a=3nbZYyFuAAAA:8 a=bc_fnt18xrrjeiQm0SMA:9 a=CjuIK1q_8ugA:10 a=EvKJbDF4Ut8A:10 a=LWPhl77mJRN9qz7e:21 a=XLFxzTp-uHGDJzZe:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 26 Aug 2013 10:37:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 07/11] [CLEANUP] trace-cmd: Split out binding a port
 and fork reader from open_udp()
Message-ID: <20130826103726.60f92fbc@gandalf.local.home>
In-Reply-To: <521AB3DF.3070505@hitachi.com>
References: <20130819094620.26597.79499.stgit@yunodevel>
	<20130819094637.26597.35505.stgit@yunodevel>
	<20130820134902.3a06e4d0@gandalf.local.home>
	<521AB3DF.3070505@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013 10:48:15 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:


> >> +static int open_udp(const char *node, const char *port, int *pid,
> >> +		    int cpu, int pagesize, int start_port)
> >> +{
> >> +	int sfd;
> >> +	int num_port;
> >> +
> >> +	num_port = udp_bind_a_port(start_port, &sfd);
> >> +	if (num_port < 0)
> >> +		return num_port;
> >
> > I don't see how num_port could be less than zero.
> 
> I think so, but trace-cmd checks whether udp_port is less than zero or
> not in create_all_readers().
> 
> May I submit the removal patch?

It's not a critical path, the check is fine. As there was a check, I
was thinking that you were expecting it to pass an error which it never
did.

Perhaps just add a comment stating that udp_bind_a_port() currently
does not return an error, but if that changes in the future, we have a
check for it now.

That way a reviewer of the code does not get confused by it.

-- Steve
