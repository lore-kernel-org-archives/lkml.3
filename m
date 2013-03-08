Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab3CHX25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:28:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab3CHX24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:28:56 -0500
Date: Fri, 8 Mar 2013 18:28:10 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 8250.nr_uarts broken in 3.7
Message-ID: <20130308232809.GO13719@hansolo.jdub.homelinux.org>
References: <20130307211426.GI13719@hansolo.jdub.homelinux.org>
 <20130307231242.GC4280@kroah.com>
 <20130308010140.GJ13719@hansolo.jdub.homelinux.org>
 <20130308013923.GA12474@kroah.com>
 <20130308212722.GL13719@hansolo.jdub.homelinux.org>
 <513A6A65.9050706@suse.cz>
 <20130308224950.GM13719@hansolo.jdub.homelinux.org>
 <513A6D1F.5000202@suse.cz>
 <513A6FD4.7000506@suse.cz>
 <513A70CF.9010800@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513A70CF.9010800@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 12:14:23AM +0100, Jiri Slaby wrote:
> On 03/09/2013 12:10 AM, Jiri Slaby wrote:
> > On 03/08/2013 11:58 PM, Jiri Slaby wrote:
> >> On 03/08/2013 11:49 PM, Josh Boyer wrote:
> >>> On Fri, Mar 08, 2013 at 11:47:01PM +0100, Jiri Slaby wrote:
> >>>> Yeah, I agree this is ugly. Just re-definining MODULE_PARAM_PREFIX at
> >>>> the end of the file should do the trick (followed by
> >>>> "module_param(nr_uarts, uint, 0644)").
> >>>
> >>> For some reason, I thought I had tried that.  Maybe I didn't.  I'll look
> >>> into it again.
> >>
> >> I see. Because we would re-define some global variables. What if we put
> >> module_param into a function?
> > 
> > Something like this?
> > #ifdef MODULE

I don't think you want this surrounded in #ifdef MODULE, do you?  That
won't let people building the driver into the kernel continue to use
8250.<whatever> on the kernel command line.

> > static void __unused splat(void) {
> 
> I meant __used. It should make no difference though.
> 
> > #       undef MODULE_PARAM_PREFIX
> > #       define MODULE_PARAM_PREFIX "8250."
> >         module_param_cb(nr_uarts, &param_ops_uint, &nr_uarts, 0644);
> >         ...
> > }
> > #endif
> > 
> > Not nice, but should work. The other way is to have those in a separate
> > file linked to 8250 (to avoid re-definition errors).

Ew.  I'll try the function first.

josh
