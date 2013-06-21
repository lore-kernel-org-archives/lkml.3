Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946029Ab3FUU2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 16:28:13 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:39406 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945951Ab3FUU2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 16:28:11 -0400
MIME-Version: 1.0
In-Reply-To: <51C4A726.1090300@sgi.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
	<20130621165142.GA32125@kroah.com>
	<51C48745.9030304@zytor.com>
	<CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com>
	<20130621185056.GA23473@kroah.com>
	<CAE9FiQVt7Fa5oTYR+yLsehboPMo86vEDsRUaqNLQD9fizD5=Fg@mail.gmail.com>
	<51C4A726.1090300@sgi.com>
Date: Fri, 21 Jun 2013 13:28:11 -0700
X-Google-Sender-Auth: tnkt48mPO6OaGe0jQLI60ZAZEZk
Message-ID: <CAE9FiQWWj8btGK68j6MO1iYwSXiF54h7SqrHCxKwXW5=fnb_0A@mail.gmail.com>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
From: Yinghai Lu <yinghai@kernel.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Robin Holt <holt@sgi.com>, Mike Travis <travis@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 12:19 PM, Nathan Zimmer <nzimmer@sgi.com> wrote:
> On 06/21/2013 02:10 PM, Yinghai Lu wrote:
>> in this way we can keep all numa etc on the place when online ram, cpu,
>> pci...
>>
>> For example if we have 32 sockets system, most time for boot is with
>> *BIOS*
>> instead of OS. In those kind of system boot is like this way:
>> only first two sockets get booted from bios to OS.
>> later use hot add every other two sockets.
>>
>> that will also make BIOS simpler, and it need to support hot-add for
>> services purpose anyway.
>>
> Yes the hot add path was one option we looked at and it did shorten boot
> times but the goal I had here is to get from power on to having the full
> machine available as quick as possible. Several clients need significant
> portions of ram for their key workloads.  So that guided my thoughts on this
> patch.

you mean boot small number sockets + hot add still take more time?
hot add ram still in serialize mode?

Yinghai
