Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab3HSWXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:23:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3HSWXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:23:39 -0400
Date: Mon, 19 Aug 2013 15:23:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Cc: Jan Dumon <j.dumon@option.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix stack corruption on some architectures
Message-ID: <20130819222338.GA3041@kroah.com>
References: <1376944647.5082.12.camel@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376944647.5082.12.camel@chimera>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 01:37:27PM -0700, Daniel Gimpelevich wrote:
> There is no need to get an interface specification if we know it's the
> wrong one; trivial change. The big thing, though, was explained in the
> #mipslinux IRC channel: 
> [Mon 2013-08-19 12:28:21 PM PDT] <headless> guys, are you sure it's not "DMA off stack" case?
> [Mon 2013-08-19 12:28:35 PM PDT] <headless> it's a known stack corruptor on non-coherent arches
> [Mon 2013-08-19 12:31:48 PM PDT] <DonkeyHotei> headless: for usb/ehci?
> [Mon 2013-08-19 12:34:11 PM PDT] <DonkeyHotei> headless: explain
> [Mon 2013-08-19 12:35:38 PM PDT] <headless> usb_control_msg() (or other such func) should not use buffer on stack. DMA from/to stack is prohibited
> [Mon 2013-08-19 12:35:58 PM PDT] <headless> and EHCI uses DMA on control xfers (as well as all the others)
> 
> Signed-off-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>


Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
