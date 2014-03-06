Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaCFEeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:34:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaCFEd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:33:59 -0500
Date: Wed, 5 Mar 2014 20:34:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Simon Horman <horms@verge.net.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Jiri Slaby <jslaby@suse.cz>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-serial@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH 2/2] serial: sh-sci: Add missing call to
 uart_remove_one_port() in failure path
Message-ID: <20140306043425.GA24704@kroah.com>
References: <1393593694-30262-1-git-send-email-geert@linux-m68k.org>
 <1393593694-30262-2-git-send-email-geert@linux-m68k.org>
 <20140306041912.GB29693@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306041912.GB29693@verge.net.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 01:19:13PM +0900, Simon Horman wrote:
> On Fri, Feb 28, 2014 at 02:21:33PM +0100, Geert Uytterhoeven wrote:
> > From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> > 
> > If cpufreq_register_notifier() fails, we have to remove the port added by
> > sci_probe_single(), which is not done by sci_cleanup_single().
> > 
> > Else the serial port stays active from the point of view of the serial
> > subsystem, and it may crash when userspace getty is started, or when the
> > loadable driver module is unloaded.
> > 
> > This was introduced by commit 6dae14216c85eea13db7b12c469475c5d30e5499
> > ("serial: sh-sci: Fix probe error paths").
> > 
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> Acked-by: Simon Horman <horms+renesas@verge.net.au>
> 
> This looks reasonable to me.
> 
> Greg, could you take this one?

Will do, thanks.
