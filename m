Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935854Ab3DHTyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:54:05 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:52383 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935775Ab3DHTyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:54:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130407174313.GA7168@lizard>
References: <1347042576-17675-1-git-send-email-bfreed@chromium.org>
	<20120908052907.GA4724@lizard>
	<20120917062302.GA768@lizard>
	<CAL_JsqK_L9nN6+oxUQzNwFjbFf3+3NroeEwzbMdPS4T6=Mnemg@mail.gmail.com>
	<20130407174313.GA7168@lizard>
Date: Mon, 8 Apr 2013 12:54:01 -0700
X-Google-Sender-Auth: 78PMME55ipShdO9vgK_BbJZfUkw
Message-ID: <CAEYUcX0rQKDGD3_pbc7JnDO6WJ_QMd8AWW+X1giNVL313wODyA@mail.gmail.com>
Subject: Re: [PATCH v6] pstore/ram: Add ramoops support for the Flattened
 Device Tree.
From: Bryan Freed <bfreed@chromium.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Rob Herring <robherring2@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for dropping the ball on this one, Anton.

Thank you for your feedback and modifications in the code.
I gotta ask, however, why do you completely remove key ramoops fields
like record_size and ftrace_size?

>From your 9/7/2012 comments (again, sorry for the delay in getting back to you):
> Personally, I don't see how this fits into device tree. It doesn't
> describe hardware, instead it's more a configuration stuff, which
> usually we try to not put into the device tree.
>
> It would be better to have a sane defaults in ramoops, instead of
> introducing more "virtual" stuff in the device tree. That is, feel
> free to change defaults if they seem to be not enough for most your
> setups.

So there are only two alternatives I can see to set these fields.
1. Pass kernel command line parameters, or
2. Modify the defaults in ram.c.

Neither of these alternatives is particularly clean to me.  The first
is shunned to avoid clutter on the command line.
And the second requires us to maintain our own version of ram.c or
push our defaults on the rest of the community.

We (ok, maybe just 'I') prefer to keep our device specific values in
the device tree, even though it is not strictly defining hardware in
the system.
What do you think of at least keeping the record_size, console_size
and ftrace_size fields as optional in the ramoops device tree
specification?

And as a more general question, why should we try not to put
configuration in the device tree?  It seems like a great (and
portable) place to put this stuff.
It certainly seems better to have it there than hardwired in the
kernel or tacked onto the kernel command line.

Thanks,

bryan.

On Sun, Apr 7, 2013 at 10:43 AM, Anton Vorontsov <anton@enomsg.org> wrote:
> On Thu, Apr 04, 2013 at 09:03:47PM -0500, Rob Herring wrote:
>> On Mon, Sep 17, 2012 at 1:23 AM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
>> > On Fri, Sep 07, 2012 at 10:29:10PM -0700, Anton Vorontsov wrote:
>> >> On Fri, Sep 07, 2012 at 11:29:36AM -0700, Bryan Freed wrote:
>> >> > When called with a non-zero of_node, fill out a new ramoops_platform_data
>> >> > with data from the specified Flattened Device Tree node.
>> >> > Update ramoops documentation with the new FDT interface.
>> >> > Update devicetree/binding documentation with pstore/ramoops.txt.
>> >>
>> >> Thanks for your work, Bryan! There were a few issues, I fixed
>> >> them myself but I need your confirmation if you're OK w/ all
>> >> the changes.
>> > [...]
>> >> So, the resulting patch is down below. But I have not pushed
>> >> it out yet, I'm waiting for your sign off. If you're OK with the
>> >> changes, please reply with
>> >> 'Signed-off-by: Bryan Freed <bfreed@chromium.org>'
>> >
>> > Bryan, have you had a chance to look into this?
>>
>> Whatever happened to this? Olof was also looking at doing a binding
>> back in Jan 2012:
>>
>> http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg09905.html
>
> I don't know. Bryan's patch looked good, I'd happily apply it. But I still
> need Bryan's Signed-off-by tag. :-/ Or, somebody needs to sign off on his
> behalf (anyone from Chromium project?). Or redo the patch.
>
> Thanks,
>
> Anton
