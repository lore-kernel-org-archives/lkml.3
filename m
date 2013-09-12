Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3ILMh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:37:29 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:44878 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab3ILMh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:37:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130909164623.GA12525@angband.pl>
References: <E1VImxG-0002w1-UA@tartarus.angband.pl>
	<CANq1E4Tv0Vb9KzWK0oa3P+-V66LqF312HZrwq_JLmHhH-v2k=Q@mail.gmail.com>
	<20130909164623.GA12525@angband.pl>
Date: Thu, 12 Sep 2013 14:37:26 +0200
Message-ID: <CANq1E4QG9ab8DpicdLt_gk95WSO5GbgF_sSrTjf--_Mt3++HtA@mail.gmail.com>
Subject: Re: [PATCH] vt: properly ignore xterm-256 colour codes
From: David Herrmann <dh.herrmann@gmail.com>
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adam

On Mon, Sep 9, 2013 at 6:46 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Mon, Sep 09, 2013 at 05:53:19PM +0200, David Herrmann wrote:
>> On Fri, Jul 12, 2013 at 10:23 PM, Adam Borowski <kilobyte@angband.pl> wrote:
>> > +                               i++;
>> > +                               if (i > vc->vc_npar)
>>
>> This should be ">=", but the for()-loop does allow your ">". So unless
>> someone fixes the for-loop to use "<" (do a ++vc->vc_npar before it,
>> if it's correct. But blindly doing "<=" is really irritating) I think
>> this is ok.
>
> The loop this switch is in does:
>         for (i = 0; i <= vc->vc_npar; i++)
> which is obviously contrary to what we're used to, but I did not want to
> rewrite nearby code to match my preferences.
>
> The change you suggest would deoptimize the code by a single unnecessary
> dereference and increment, which is negligible, but since the whole cost
> of speedier version is having <= instead of < in the loop, I'm not so
> certain this is a good idea.

This was just my comment on the weird for-loop. No need to touch it at
all, I just wondered whether anyone knows why we use <= instead of
just < here.

> [...]
>> Btw., you should put Greg Kroah-Hartman and Andrew Morton on CC. Both
>> are the most likely to pick this up.
>
> Thanks for the suggestion.  I've sent the patch two days ago to Jiri Slaby
> (listed as a maintainer besides Greg) together with a newbie question, but
> he's apparently busy.
>
> I've got more changes for the vt, but there's no hurry, I wanted to test
> the waters with a single minor one in 3.12 first.

Jiri Slaby maintains the TTY subsystem (together with Greg). This does
not include the VT layer, though. drivers/tty/vt/ and
drivers/video/console/ are unmaintained. You need to get the attention
of any maintainer who is willing to take it through their tree (hint:
most maintainers don't dare touching the VT layer. Greg and Andrew
were brave enough in the past.).

I'm willing to review your patches, but history taught me touching the
VT layer is a waste of time. Still, good luck.

Regards
David
