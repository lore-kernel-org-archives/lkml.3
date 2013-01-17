Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab3AQIhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:37:16 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:45459 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759231Ab3AQIhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:37:13 -0500
MIME-Version: 1.0
In-Reply-To: <20130116194759.GA4502@redhat.com>
References: <87wqvdli1o.fsf@xmission.com>
	<1358344859.4593.66.camel@falcor1>
	<20130116144836.GB29845@redhat.com>
	<1358350391.4593.112.camel@falcor1>
	<20130116155406.GC29845@redhat.com>
	<1358357079.4593.135.camel@falcor1>
	<20130116182146.GE29845@redhat.com>
	<1358361912.4593.162.camel@falcor1>
	<20130116185741.GA3038@redhat.com>
	<1358365044.4593.186.camel@falcor1>
	<20130116194759.GA4502@redhat.com>
Date: Thu, 17 Jan 2013 10:37:11 +0200
Message-ID: <CALrft9-vWX6U+g5KduHWK7s_PE9Le6NL7B478MzGRjS40a34tw@mail.gmail.com>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Elena Reshetova <elena.reshetova@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org,
        Ryan Ware <ryan.r.ware@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Ok, that's the point I am missing. So I can sign a file and signatures
>> > are in a separate file. And these signatures are installed in extended
>> > attributes at file installation time (IOW rpm installation time) on
>> > target.
>> >
>> > If all this works, this sounds reasonable so far. Except the point of
>> > disabling ptrace and locking down memory.
>> >
>> > So what's the state of above work. Is there something I can play with.

Let me try to comment on this one a bit.
Thewhole idea behind extending rpm plugin interface was to have an extensive
 set of hooks that would allow rpm plugins to perform needed additional things.
Plugins can be different dependening on a ditsibution need, and if a
distribution
needs to bootstrap IMA signatures, this can also be done in  one of
plugins hooks.

Now about hook status: we have so far integrated to rpm master branch
only a subset of hooks.
Mainly the cause has been that I am far from working on it all the
time unfortunately.
Currently I am looking at the filesystem hooks and hoping to send some
version of that patch soon.

When the hooks will be integrated,it is really up to plugin
implementor to design how thing wil happen.
There will be a hook that would be called after file from a package is
placed to filesystem, where
plugin can do many things, like setting MAC labels or setting IMA
signatures on a file.
The way signature will be stored in a package is also currently open,
there can be a number of options here.
You can define a special rpm header TAG and during package build
embeed all the informaiton about
signatures there together with the file name. This way plugin can
parse the header tag info, get all signatures info
and when the right hook is called, setup the IMA signature attribute.
But as I said, this is just one way of doing it
and may not be the best one.

Best Regards,
Elena.
