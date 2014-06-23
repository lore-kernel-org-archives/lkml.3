Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaFWG3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:29:53 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:44953 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaFWG3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:29:51 -0400
MIME-Version: 1.0
In-Reply-To: <1403487015.18747.23.camel@joe-AO725>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	<1403487015.18747.23.camel@joe-AO725>
Date: Mon, 23 Jun 2014 08:29:49 +0200
Message-ID: <CA+rthh8rGQX9pKUC3rGfaguQ+TVXqXqXuUiHzE6Ga0tQE1ch_A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Mathias Krause <minipli@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: David Daney <david.daney@cavium.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 June 2014 03:30, Joe Perches <joe@perches.com> wrote:
> On Mon, 2014-06-23 at 00:46 +0200, Mathias Krause wrote:
>> This RFC series tries to address the problem of dangling strings of
>> __init functions after initialization, as well as __exit strings for
>> code not even included in the final kernel image. The code might get
>> freed, but the format strings are not.
>>
>> One solution to the problem might be to declare variables in the code
>> and mark those variables as __initconst. That, though, makes the code
>> ugly, as can be seen, e.g., in drivers/hwmon/w83627ehf.c -- a pile of
>> 'static const char[] __initconst' lines just for the pr_info() call.
>
> Another solution might be, as David Daney suggested, using
> gcc 4.5+ plug-ins to extract these format strings and
> const char * arrays into specific sections automatically.
>
> https://lkml.org/lkml/2009/7/21/483
>
> Seems feasible, but there might be a negative of string
> duplication in multiple sections that would otherwise
> be consolidated into a single object.
>

There is currently no infrastructure for gcc plugins in the kernel
tree. And using plugins might make the kernel even more depended on a
particular gcc version, as the plugin API changes with every version.
In fact, there is none, beside "use every exported function you can
get your hand on". And that API breaks with each and every new version
of gcc. This would put quite a bigger maintenance burden on such an
approach than providing appropriate wrappers, fixing the obvious
candidates and adding a checkpatch warning.

Thanks,
Mathias
