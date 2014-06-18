Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966448AbaFRMUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:20:21 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:42718 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966122AbaFRMUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:20:19 -0400
Date: Wed, 18 Jun 2014 13:20:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH 11/21] mfd: use devm_irq_of_parse_and_map() where
 appropriate
Message-ID: <20140618122011.GG8300@lee--X1>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
 <1401880402-30091-12-git-send-email-nyushchenko@dev.rtsoft.ru>
 <20140617151226.GM29841@lee--X1>
 <53A0606C.6030400@dev.rtsoft.ru>
 <20140618084838.GR21030@lee--X1>
 <53A178AD.3060003@dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53A178AD.3060003@dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Nikita Yushchenko wrote:

> >>Hmm...  probably it was too early to apply this?  I was just going
> >>to prepare v2, based on discussion...
> >
> >Which discussion?
> 
> One you are replying in?
> 
> https://lkml.org/lkml/2014/6/4/136

I only see what's in my mailbox.  If you didn't send me any other
patches, which were subsequently commented on, I wouldn't have seen
said comments/discussion.

> >>Also, applying only 11/21, without 01/21, will just cause build errors ...
> >
> >CC'ing me on this patch alone when you know you have build
> >dependencies on other patches in the set is a bad idea.  Failing to
> >mention that you wanted the patch to be handled in a special and/or
> >unconventional way is an even worse idea.
> >
> >How are you expecting this patch(-set) to be handled?
> 
> Sorry but I did not CC you this patch.
> 
> I sent entire patchset to mailing lists and to maintainers of IRQ
> and device tree subsystems.
> I used git send-email, and all mails went out to the same recipients.
> Recipient addresses extracted using scripts/get_maintainer.pl
> applied to the "main" patch of the patchset.
> I did not sent entire patchset to maintainers of individual changed
> drivers because this makes recipient address too big and too much
> looks like spamming.
> I did not send individual patches to individual addresses to avoid
> cases of partially-applied patchset that will just break things
> (actually this is what happened with 11/21)
> 
> I'm quite sorry if I did things wrong, it was my first attempt to
> sent patchset with tree-wide fixes. However, I don't see what I've
> done wrong... any hints on that will be appreciated.

This is quite tricky due to the size of the set and the number of
subsystems it touches.  The optimum method is to have the smallest
patch-set and touch only the very least amount of subsystems as
possible.  This is almost always feasible, however in the small cases
that it's not, the alternative is to let the maintainers know what
your plans are i.e. if you're only looking for Acks and that you (or
another maintainer) will send out a pull-request to all of the other
maintainers to suck into their trees.  This is required to prevent
conflicts during the merge-window.  If you want to send such messages
to all of the parties without spamming them with the rest of the set,
you can do so in the commit message (which you can then keep in Git
for subsequent revisions).

For example:

> From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
>
> This avoids leak of IRQ mapping on error paths, and makes it possible
> to use devm_request_irq() without facing unmap-while-handler-installed
> issues.
>
> Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
> ---
> My intention is to take this entire set through the <SUBSYSTEM> tree.
> To facilitate this I'm collecting maintainer Acks.  Once applied to
> the <SUBSYSTEM> tree a pull-request will be sent out in order to avoid
> merge conflicts at pull-time.
> ---
>  drivers/mfd/max8997.c |    4 +++-
>  drivers/mfd/max8998.c |    4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index 8cf7a01..6ae0786 100644
> --- a/drivers/mfd/max8997.c
> +++ b/drivers/mfd/max8997.c
> [...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
