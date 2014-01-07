Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaAGRXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:23:53 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:46335 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaAGRXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:23:47 -0500
Date: Tue, 7 Jan 2014 09:23:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/4] firmware loader: simplify holding module for
 request_firmware
Message-ID: <20140107172342.GA31842@core.coreip.homeip.net>
References: <1370520110-32293-1-git-send-email-ming.lei@canonical.com>
 <1370520110-32293-3-git-send-email-ming.lei@canonical.com>
 <20140107075600.GC20074@core.coreip.homeip.net>
 <CACVXFVNMofvYpsiFFxFaCtN7XHAEtBmJEHCW2mJRS4x+O0+utg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNMofvYpsiFFxFaCtN7XHAEtBmJEHCW2mJRS4x+O0+utg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 10:53:57PM +0800, Ming Lei wrote:
> Hi Dmitry,
> 
> On Tue, Jan 7, 2014 at 3:56 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > Hi Ming,
> >
> > On Thu, Jun 06, 2013 at 08:01:48PM +0800, Ming Lei wrote:
> >> module reference doesn't cover direct loading path, so this patch
> >> simply holds the module in the whole life time of request_firmware()
> >> to fix the problem.
> >
> > This does not make sense to me. If request_firmware() is executing that
> > means some other module references it and module refcount already
> > reflects that.
> 
> Yes, you are right, holding this module references in both
> request_firmware() and request_firmware_direct() shouldn't
> be necessary.
> 
> >
> > We needed to pin module before Tejun's work ensuring that currently open
> > sysfs entries won't keep related kobjects pinned after kernel marked
> > them inactive. We can probably delete __module_get()/module_put() from
> > firmware_class.c now.
> 
> But holding the reference for request_firmware_nowait() is needed.

Ah, yes, of course.

Thanks.

-- 
Dmitry
