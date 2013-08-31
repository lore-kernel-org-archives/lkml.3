Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab3HaOdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 10:33:10 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51474 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab3HaOdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 10:33:08 -0400
Message-ID: <5221FE97.1050504@gmail.com>
Date: Sat, 31 Aug 2013 23:32:55 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: agk@redhat.com
CC: dm-devel@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org
Subject: Re: [dm-devel] [RFC] dm-writeboost: plan to go to staging
References: <521EA567.1070801@gmail.com> <20130829020555.GA26206@kroah.com> <20130829033023.GH4872@agk-dp.fab.redhat.com>
In-Reply-To: <20130829033023.GH4872@agk-dp.fab.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Alasdair.

I will reply to some of your comments
that is not answered up to now.

> The documentation file will eventually need rewriting to follow the same
> format as the other targets recently added to the kernel.  We document
> the kernel interface rather than any particular userspace tools, which
> just have the status of convenient examples.
dm-writeboost can be used by kicking kernel interfaces but
it is not recommended.
My userspace tools take care of all the
implications in using the kernel interfaces.
The fact dm-writeboost supports shared-caching and
write-back caching with auto-modulated migration
puts the interfaces and implementations under some constraints.
That's simply a tradeoff.

OK, I will document the kernel interfaces
and also mention the userspace tools.

> (Your code also needs many more comments inline to explain what it does
> and how it works.)
Comments are substantially noise is my philosophy.
I will add comments with given feedback clearly mentioning
what is clear and what is not clear about the source code.
Even in that case,
I'd better polish the code rather than write comments.

> Another little thing I noticed: look into using something like
> __dm_bless_for_disk() for your metadata and clearly segregate your
> on-disk structures and document the layout.
I couldn't understand what is __dm_bless_for_disk() for.
What does the word "bless" mean in this context?

By the way,
dm-cache and dm-writeboost are definitely different in a way that
dm-cache has an another disk for metadata while dm-writeboost doesn't.
dm-writeboost packs metadata and data within a log and
submit it to the cache device like log-structured filesystem.

So, the annotation checks can not be appropriated
to apply to dm-writeboost.

And what about moving these macros to
include/linux/device-mapper.h?

Akira

On 8/29/13 12:30 PM, Alasdair G Kergon wrote:
> On Wed, Aug 28, 2013 at 07:05:55PM -0700, Greg KH wrote:
>> For staging drivers, I need a TODO file that lists
>> what needs to be done to the code to get it into a mergable state for
>> the "real" part of the kernel,
> 
> Two simple requirements before putting your proof-of-concept into staging
> if you want to work that way:
> 
> 1) Drop the major version number to 0.  Version 1 is reserved for
> supported modules.
> 
> 2) Agree a new and meaningful target name with us so you don't have to
> change it later.  "lc" means nothing, I'm afraid.
> 
> Then in general terms, you should continue to compare your device-mapper
> target with the existing targets and where there are differences, either
> change your target to be like something that already exists, or be ready
> to explain why that can't or shouldn't be done.
> 
> In particular, the interface and architecture will need substantial
> changes and working these out should be your highest priority.
> 
> For example, you write:
> 
>   Be careful, you MUST create all the LVs as the destinations of
>   the dirty blocks on the cache device before this operation.  Otherwise,
>   the kernel may crash.
> 
> I read a statement like that as an indication of an interface or
> architectural problem.  The device-mapper approach is to 'design out'
> problems, rather than relying on users not doing bad things.
> Study the existing interfaces used by other targets to understand
> some approaches that proved successful, then decide which ones
> come closest to your needs.
> 
> (Your code also needs many more comments inline to explain what it does
> and how it works.)
> 
> The documentation file will eventually need rewriting to follow the same
> format as the other targets recently added to the kernel.  We document
> the kernel interface rather than any particular userspace tools, which
> just have the status of convenient examples.
> 
> Another little thing I noticed: look into using something like
> __dm_bless_for_disk() for your metadata and clearly segregate your
> on-disk structures and document the layout.
> 
> Alasdair
> 

