Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab3JHKOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:14:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62711 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab3JHKOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:14:18 -0400
Message-ID: <1381227252.15686.9.camel@marge.simpson.net>
Subject: Re: perf: perf sched lat segfault - bisected
From: Mike Galbraith <bitbucket@online.de>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 08 Oct 2013 12:14:12 +0200
In-Reply-To: <CABPqkBRMa7rawfvQ2Sunc2tr87s_WqT_7GYac6+x=SNZoJSueg@mail.gmail.com>
References: <1381221715.15686.3.camel@marge.simpson.net>
	 <CABPqkBRMa7rawfvQ2Sunc2tr87s_WqT_7GYac6+x=SNZoJSueg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:5IFqXAHzFxFDv8f7nxR0vdfBsg6itkrEVqpP+xdlAlV
 irA5ON7yBhK8Uf+OBMT09YPY74juDH1QtoN7FN+XYtAoXaFc8e
 1JXtu1nmxOZ9uBVtGn0w+iVz3zEWci+f0YIH1vusUz/QQZtoWn
 KaV0NQsMcZnspGFUgvAhaLUlqc2lA5QhvGljoRWtd5tejMkeWd
 Egpx8j1RBRTTOoI4VCgCJnoQQDwZsOOlvOgXSEB1eXEbSuEDOj
 vlY8NZ/TFMMRKNv0/9P0hzbhCmmS+mhB1LKAujTSi5et81puXo
 rBxE20G2DoBpJMdrw99SZKmUknwLBsqc5oOGJq55DTB2ZlcagT
 xx70EwcEcVbB2fLoeD+Lea+yT4FwIUoZh86PCvWUyGBiLNt6F6
 y10YcS/oeNTTw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 11:23 +0200, Stephane Eranian wrote: 
> On Tue, Oct 8, 2013 at 10:41 AM, Mike Galbraith <bitbucket@online.de> wrote:
> > Box: Q6600
> >
> > Reproducer:
> > perf sched record -- sleep 1
> > perf sched lat (boom)
> >
> I don't understand the test case here.
> If I do this, perf sched lat complains of no trace records
> and no kernel crash. Could you provide the full cmdline?

Hm.  That was it, just like so.

marge:/usr/local/src/kernel/linux-3.x.git/tools/perf # ./perf sched record -- sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.763 MB perf.data (~33348 samples) ]
marge:/usr/local/src/kernel/linux-3.x.git/tools/perf # ./perf sched lat
Segmentation fault
marge:/usr/local/src/kernel/linux-3.x.git/tools/perf #

	-Mike

