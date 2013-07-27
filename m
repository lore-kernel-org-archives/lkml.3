Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab3G0Lfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 07:35:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26379 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3G0Lfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 07:35:40 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=qUJAF7m9tmYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Vl5wU4Dj6BYA:10 a=Q70VgaEAw8nMnW5zWv8A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374924938.6580.46.camel@gandalf.local.home>
Subject: Re: [PATCH v2 2/2] tracing: Shrink the size of struct
 ftrace_event_field
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Li Zefan <lizefan@huawei.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 27 Jul 2013 07:35:38 -0400
In-Reply-To: <20130727084528.GA6923@pd.tnic>
References: <51F08D1B.1080300@huawei.com> <51F08D4B.3010201@huawei.com>
	 <1374851376.6580.34.camel@gandalf.local.home> <51F33F41.9040902@huawei.com>
	 <1374896842.6580.44.camel@gandalf.local.home>
	 <20130727084528.GA6923@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-27 at 10:45 +0200, Borislav Petkov wrote:
>  
> > > +	field->filter_type = filter_type;
> > >  	field->offset = offset;
> > >  	field->size = size;
> > > -	field->is_signed = is_signed;
> > > +	field->is_signed = !!is_signed;
> > > +
> > > +	VERIFY_SIZE(filter_type);
> > > +	VERIFY_SIZE(offset);
> > > +	VERIFY_SIZE(size);
> 
> Isn't this wrap-a-macro-with-another-more-obscure-macro not a bit too
> much?
> 
> I mean,
>   	WARN_ON(filter_type > field->filter_type)
> 
> is much more readable than VERIFY_SIZE IMO.

Fair enough. My first version of the test was a bit more complex, and
then I simplified it, but kept the macro. Either is fine to me. But
yeah, I can see the point that the test isn't that complex, and there's
only three tests. If there were more or the test a bit more complex,
then I would definitely want the macro.

But you know me. I LOVE macros!

-- Steve


