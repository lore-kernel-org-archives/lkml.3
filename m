Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3FDWxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:53:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41238 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754255Ab3FDWn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:57 -0400
X-Sasl-enc: j/UeW2GC5ErhGGX8wXBnwo367GOpVSCIjGsOij5piD1V 1370385835
Date: Tue, 4 Jun 2013 15:44:24 -0700
From: Greg KH <greg@kroah.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [hv] BUG: kernel freezes after [   13.356381] PCI: CLS 0 bytes,
 default 64
Message-ID: <20130604224424.GB533@kroah.com>
References: <20130604141536.GA13324@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604141536.GA13324@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 10:15:36PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg (kernel freezes at the end of it) and the first bad commit is
> 
> commit cf6a2eacbcb2593b5b91d0817915c4f0464bb534
> Author: K. Y. Srinivasan <kys@microsoft.com>
> Date:   Thu Dec 1 09:59:34 2011 -0800
> 
>     drivers: hv: Don't OOPS when you cannot init vmbus
>     
>     The hv vmbus driver was causing an OOPS since it was trying to register drivers
>     on top of the bus even if initialization of the bus has failed for some
>     reason (such as the odd chance someone would run a hv enabled kernel in a
>     non-hv environment).
>     
>     Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
>     Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
>     Cc: stable <stable@vger.kernel.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> [   13.356381] PCI: CLS 0 bytes, default 64

Ick, not good.  K.Y., any reason why I shouldn't just revert this?

thanks,

greg k-h
