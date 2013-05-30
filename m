Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab3E3WxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 18:53:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3E3WxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 18:53:09 -0400
Date: Fri, 31 May 2013 07:25:42 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] ACPI: Fix potential NULL pointer dereference in
 acpi_processor_add()
Message-ID: <20130530222542.GD1630@kroah.com>
References: <519E0F2A.4070602@linaro.org>
 <51A5E177.3090809@fold.natur.cuni.cz>
 <51A6B9A2.8090904@linaro.org>
 <2969934.XTKV7y9VVT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2969934.XTKV7y9VVT@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 03:57:58PM +0200, Rafael J. Wysocki wrote:
> On Thursday, May 30, 2013 10:29:54 AM Hanjun Guo wrote:
> > On 2013-5-29 19:07, Martin Mokrejs wrote:
> > > Hanjun Guo wrote:
> > >> On 2013-5-29 7:30, Rafael J. Wysocki wrote:
> > >>> On Thursday, May 23, 2013 08:44:26 PM Hanjun Guo wrote:
> > >>>> In acpi_processor_add(), get_cpu_device() will return NULL sometimes,
> > >>>> although the chances are small, I think it should be fixed.
> > >>>>
> > >>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> > >>>
> > >>> This patch isn't necessary any more after the changes queued up for 3.11
> > >>> in the acpi-hotplug branch of the linux-pm.git tree.
> > >>
> > >> Ok, I noticed your patch set, just drop my patch.
> > > 
> > > But shouldn't this go to stable at least? I checked linux-3.9.4
> > > and it applies fine. Whether this is relevant for other stable
> > > series I will leave up to somebody else. ;)
> > 
> > Hi Rafeal,
> > 
> > What's your opinion on Martin's suggestion?
> 
> Well, this is kind of hard to say.  We generally don't apply patches to -stable
> that don't have mainline counterparts.
> 
> Greg, I wonder what your opinion is?

We do not apply patches to -stable that are not in Linus's tree, unless
there is no problem in Linus's tree due to a major rewrite of the code,
and it has been confirmed that the same problem isn't there.

thanks,

greg k-h
