Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab3HNARH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 20:17:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29155 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab3HNARF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 20:17:05 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=lRvUdbBmi18A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=bpXn7r4kvEgA:10 a=pGLkceISAAAA:8 a=ke0KttNHpxfv5ofVA6sA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 13 Aug 2013 20:17:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] module: Allow parameters without arguments
Message-ID: <20130813201702.5aeca54c@gandalf.local.home>
In-Reply-To: <CAKi4VALgK94oiv68x6XxEnwbYJcAhQDwgNoAT=KSGmuV01zR+g@mail.gmail.com>
References: <20130813210228.989279359@goodmis.org>
	<CAKi4VALgK94oiv68x6XxEnwbYJcAhQDwgNoAT=KSGmuV01zR+g@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 20:34:58 -0300
Lucas De Marchi <lucas.de.marchi@gmail.com> wrote:

 
> so in kcmdline we would have modulename.param instead of modulename.param=1?
> 
> I guess we need to update kmod then, because currently we ignore and
> treat this case as a wrong token. From a quick look, allowing it in
> kmod would be as simple as removing a condition check.
> 
> Lucas De Marchi

Note, both will still work. And it didn't change much. Today, anything
that uses "module_param()" with bool type (a quick git grep shows 570
users), already do not require a value.

Randomly looking at one... drivers/input/mouse/synaptics_i2c.c, you can
just do:

 insmod synaptics_i2c.ko no_filter

no need to add a "=1" to that.

But anything else will still require a value. I just want to allow
other parameters that act like a boolean to not require one.

-- Steve
