Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbaK1AHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 19:07:22 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61418 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaK1AHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 19:07:21 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 5/8] of/overlay: Introduce DT overlay support
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>
In-Reply-To: <1417021025.29407.66.camel@x220>
References: <1416533715-9758-1-git-send-email-grant.likely@linaro.org>
	<1416533715-9758-6-git-send-email-grant.likely@linaro.org>
	<1417007515.29407.54.camel@x220>
	<CACxGe6tw1FJsSvf-7u2Lx143_-GOWr3b-fLu1kCzK4JCCEwGSA@mail.gmail.com>
	<1417021025.29407.66.camel@x220>
Date: Fri, 28 Nov 2014 00:07:13 +0000
Message-Id: <20141128000713.1A9B8C40A7F@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014 17:57:05 +0100
, Paul Bolle <pebolle@tiscali.nl>
 wrote:
> On Wed, 2014-11-26 at 15:18 +0000, Grant Likely wrote:
> > On Wed, Nov 26, 2014 at 1:11 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > > On Fri, 2014-11-21 at 01:35 +0000, Grant Likely wrote:
> > >> From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> > >>
> > >> Overlays are a method to dynamically modify part of the kernel's
> > >> device tree with dynamically loaded data. Add the core functionality to
> > >> parse, apply and remove an overlay changeset. The core functionality
> > >> takes care of managing the overlay data format and performing the add
> > >> and remove. Drivers are expected to use the overlay functionality to
> > >> support custom expansion busses commonly found on consumer development
> > >> boards like the BeagleBone or Raspberry Pi.
> > >>
> > >> The overlay code uses CONFIG_OF_DYNAMIC changesets to perform the low
> > >> level work of modifying the devicetree.
> > >>
> > >> Documentation about internal and APIs is provided in
> > >>       Documentation/devicetree/overlay-notes.txt
> > >>
> > >> v2:
> > >> - Switch from __of_node_alloc() to __of_node_dup()
> > >> - Documentation fixups
> > >> - Remove 2-pass processing of properties
> > >> - Remove separate ov_lock; just use the DT mutex.
> > >> v1:
> > >> - Drop delete capability using '-' prefix. The '-' prefixed names
> > >> are valid properties and nodes and there is no need for it just yet.
> > >> - Do not update special properties - name & phandle ones.
> > >> - Change order of node attachment, so that the special property update
> > >> works.
> > >>
> > >> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> > >> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> > >
> > > Now commit 7518b5890d8a ("of/overlay: Introduce DT overlay support"),
> > > included in today's linux-next (next-20141126).
> > 
> > Yes, I pushed it out yesterday. Beyond merely stating a fact, I don't
> > understand what you're trying to point out here. Is this commit
> > causing a problem?
> 
> Yes, the issue I pointed out in my next remark.
> 
> And I add a boring line like that to my messages to make sure its
> readers (which could be me, in case nothing happens within a week or
> two) have all the facts at hand when handling them. It spares them the
> trouble to look up these facts themselves.
> 
> Perhaps this lines was ambiguous. Should I rephrase it? Please note that
> I usually use proper sentences. This one was a bit blunt. 

I was confused because the statement above wasn't in reference to
anything in particular. It was just a statement. If you had said
something like "Today's linux-next has the following problem caused by
commit 7518b5890 ('...')", then I think it would have been clearer.

> 
> > >>[...]
> > >> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> > >> index fbe8f8d418f7..18b2e2539f84 100644
> > >> --- a/drivers/of/Kconfig
> > >> +++ b/drivers/of/Kconfig
> > >> @@ -84,4 +84,11 @@ config OF_RESERVED_MEM
> > >>  config OF_RESOLVE
> > >>       bool
> > >>
> > >> +config OF_OVERLAY
> > >> +     bool
> > >> +     depends on OF
> > >> +     select OF_DYNAMIC
> > >> +     select OF_DEVICE
> > >
> > > There's currently no Kconfig symbol OF_DEVICE. So this select is now a
> > > nop. Will that symbol be added in a future patch?
> > 
> > That's a hanger-on from an earlier version of the patch. I'll apply a
> > fixup patch to remove it.
> 
> I've seen your fixup already. It turns out OF_DEVICE is a symbol that
> was removed in v3.11.

Thanks for the testing and bug report.

g.

