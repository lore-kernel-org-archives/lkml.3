Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaCXEdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 00:33:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaCXEdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 00:33:39 -0400
Date: Sun, 23 Mar 2014 21:35:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Patrick Lai <plai@codeaurora.org>, Mark Brown <broonie@linaro.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.13 110/149] ASoC: pcm: free path list before exiting
 from error conditions
Message-ID: <20140324043513.GD6471@kroah.com>
References: <20140321000436.377902063@linuxfoundation.org>
 <20140321000440.772268771@linuxfoundation.org>
 <1395503588.2770.69.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395503588.2770.69.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 03:53:08PM +0000, Ben Hutchings wrote:
> On Thu, 2014-03-20 at 17:04 -0700, Greg Kroah-Hartman wrote:
> > 3.13-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Patrick Lai <plai@codeaurora.org>
> > 
> > commit e4ad1accb28d0ed8cea6f12395d58686ad344ca7 upstream.
> > 
> > dpcm_path_get() allocates dynamic memory to hold path list.
> > Corresponding dpcm_path_put() must be called to free the memory.
> > dpcm_path_put() is not called under several error conditions.
> > This leads to memory leak.
> 
> This is broken.  dpcm_path_get() may return -ENOMEM and not initialise
> the list at all.
> 
> If snd_soc_dapm_dai_get_connected_widgets() can fail (I don't think it
> can) then dpcm_path_get() should be responsible for freeing the list
> before returning.

Thanks, now dropped.

greg k-h
