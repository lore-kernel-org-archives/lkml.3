Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaHZPzC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:55:02 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46308 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbaHZPzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:55:00 -0400
X-Sasl-enc: 1n4plJZ8qtBBYXs4vIBdPhToho0Jqb+o7NE8YlTZ3Pjn 1409068499
Date: Tue, 26 Aug 2014 08:54:18 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thunderbolt: Clear hops before overwriting
Message-ID: <20140826155418.GA3034@kroah.com>
References: <1409067741-3378-1-git-send-email-andreas.noever@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409067741-3378-1-git-send-email-andreas.noever@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 05:42:21PM +0200, Andreas Noever wrote:
> Zero hops in tb_path_activate before writing a new path.
> 
> This fixes the following scenario:
>  - Boot with a coldplugged device
>  - Unplug device
>  - Plug device back in
>  - PCI hotplug fails
> 
> The hotplug operation fails because our new path matches the (now
> defunct) path which was setup by the firmware for the coldplugged
> device. By writing zeros before writing our path configuration we can
> force thunderbolt to retrain the path.
> 
> Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
> ---
>  drivers/thunderbolt/path.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)

Should this get in for 3.17-final or can it wait for 3.18?  I'm thinking
3.17, but want to make sure.

thanks,

greg k-h
