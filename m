Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab3CHWfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:35:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7157 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3CHWfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:35:03 -0500
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=TmKWfNb9ACYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=71SFzsyAHQcA:10 a=H2-ciVNtAAAA:8 a=Jq7iGXmwOV9XmaemwiIA:9 a=PUjeQqilurYA:10 a=Gq9PjJF5URkA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362782100.31874.100.camel@gandalf.local.home>
Subject: Re: [PATCH v2] init: Scream bloody murder if interrupts are enabled
 too early
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ard van Breemen <ard@telegraafnet.nl>
Date: Fri, 08 Mar 2013 17:35:00 -0500
In-Reply-To: <20130308135540.0739f48551fc600604607c99@linux-foundation.org>
References: <1362754092.31874.97.camel@gandalf.local.home>
	 <20130308135540.0739f48551fc600604607c99@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-08 at 13:55 -0800, Andrew Morton wrote:
> On Fri, 08 Mar 2013 09:48:12 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Also, while examining other warnings in init/main.c, I found two other
> > locations that deserve a bloody murder scream if their conditions are
> > hit, and updated them accordingly.
> 
> So the whole effect of this patch is to spew a larger volume of
> unuseful stuff (such as uninteresting stack traces) onto the console so
> people are more likely to notice it?

Yep!

>   Hmpf.  I think I prefer
> 
> akpm3:/usr/src/25> banner "OMG\!\!"      
> ####### #     #  #####    ###     ###
> #     # ##   ## #     #   ###     ###
> #     # # # # # #         ###     ###
> #     # #  #  # #  ####    #       #
> #     # #     # #     #
> #     # #     # #     #   ###     ###
> ####### #     #  #####    ###     ###
> 

I rather print out this: http://www.100mb.nl/


> 
> Maybe we should reduce the amount of goop we printk out at boot
> instead ;)

But I seldom read the boot messages, that's what tools are for ;-)

ktest.pl keys off of a stack trace, and so does the tip automated tools,
and I'm sure other tools do too. Not sure anything looks for a simple
"This is a bug, don't do that".

-- Steve


