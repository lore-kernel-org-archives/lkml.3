Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3ARC7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 21:59:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:51215 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab3ARC7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 21:59:10 -0500
Date: Thu, 17 Jan 2013 19:00:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>
Subject: Re: [PATCH] platform: Fix platform device resource linking
Message-ID: <20130118030017.GA11423@kroah.com>
References: <1357252270-5955-1-git-send-email-panto@antoniou-consulting.com>
 <20130103224020.GB4571@kroah.com>
 <CD23CDD8-5740-4649-8876-ADDFCFF30C35@antoniou-consulting.com>
 <20130117163159.GD1396@kroah.com>
 <95056678-DF1A-4C49-BEAE-C5EBD7E56405@antoniou-consulting.com>
 <20130117170719.GB9163@kroah.com>
 <87DCB3B7-0A5A-42F0-BF9C-0E91B56960C6@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87DCB3B7-0A5A-42F0-BF9C-0E91B56960C6@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 07:27:21PM +0200, Pantelis Antoniou wrote:
> >> In a nutshell, we have to exercise the platform device subsystem, in ways
> >> that never happened before, so all sorts of weird bugs that no-one has seen
> >> before.
> > 
> > Why do you have to do this?  What are you doing that is so different
> > from everyone else?  What drivers are you using that trigger this type
> > of thing?
> > 
> 
> This is all part of a larger patchset; I guess you weren't directly CCed.
> The name of the patchset is 'Introducing Device Tree Overlays' and is a
> method of changing the live device tree and have the changes reflected to
> the kernel's state.

Ok, no wonder I was confused :)

How about cc:ing me on the next round of these patches, all of the,
which will give me the proper background as to what is going on?

> >> In that case, the code path for creating platform devices from DT is
> >> not the same as the one that is used when creating platform device from
> >> a board file.
> > 
> > Why not?
> > 
> 
> Because while DT creates platform devices, it doesn't use the platform device
> methods to do so, rather than builds the platform device itself. This is 
> something that was overlooked.

Can't this be fixed?  What does the platform device core need to do to
resolve this?

thanks,

greg k-h
