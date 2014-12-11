Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbaLKXjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:39:39 -0500
Received: from ozlabs.org ([103.22.144.67]:45701 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759110AbaLKXji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:39:38 -0500
Message-ID: <1418341176.20629.2.camel@ellerman.id.au>
Subject: Re: Re: [PATCH] ftracetest: Replace usleep with sleep 0.000001
From: Michael Ellerman <mpe@ellerman.id.au>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 12 Dec 2014 10:39:36 +1100
In-Reply-To: <548927B1.2010502@hitachi.com>
References: <1418186307-1259-1-git-send-email-mpe@ellerman.id.au>
	 <CAM9d7cgY6t7_XB+SryQft_BA0zbtcKN1ZrfQ-qONtb-SkB89Jw@mail.gmail.com>
	 <548927B1.2010502@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-11 at 14:12 +0900, Masami Hiramatsu wrote:
> Hi,
> 
> (2014/12/10 17:19), Namhyung Kim wrote:
> > Hi Michael,
> > 
> > On Wed, Dec 10, 2014 at 1:38 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> >> usleep is a Fedoraism, it's not generally available on Debian based
> >> systems AFAICS.
> >>
> >> GNU sleep accepts a floating point argument, so use that instead.
> > 
> > I tested it on busybox not Debian, sorry.  But it seems busybox's
> > sleep doesn't support floating point argument..
> > 
> >   / # ls -l `which sleep`
> >   lrwxrwxrwx     1  root     rooot       7 May 22  2014  /bin/sleep -> busybox
> > 
> >   / # sleep 0.1
> >   sleep: invalid number '0.1'
> 
> I also have same result. Basically, ftracetest should be able to run on busybox.

Yeah OK.

> So, I think we'd better check whether usleep is available, and if not, fallback
> to sleep like as below.
> 
>   if which usleep &> /dev/null; then
>     usleep 1
>   else
>     sleep 0.000001
>   fi

Why do we need to call (u)sleep anyway? It's generally a bad sign when tests
use sleep as it's asking for random timing related failures to creep in.

cheers


