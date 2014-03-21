Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966127AbaCUAg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:36:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965776AbaCUAgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:36:53 -0400
Date: Thu, 20 Mar 2014 17:38:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3.10 76/85] Fix mountpoint reference leakage in linkat
Message-ID: <20140321003816.GA26973@kroah.com>
References: <20140321000558.606667505@linuxfoundation.org>
 <20140321000609.596835128@linuxfoundation.org>
 <3E72E44E-23C8-4040-8495-0A61C9C4316A@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E72E44E-23C8-4040-8495-0A61C9C4316A@linuxhacker.ru>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 08:11:22PM -0400, Oleg Drokin wrote:
> Hello!
> 
> On Mar 20, 2014, at 8:10 PM, Greg Kroah-Hartman wrote:
> 
> > 3.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Oleg Drokin <green@linuxhacker.ru>
> > 
> > commit d22e6338db7f613dd4f6095c190682fcc519e4b7 upstream.
> > 
> > Recent changes to retry on ESTALE in linkat
> > (commit 442e31ca5a49e398351b2954b51f578353fdf210)
> > introduced a mountpoint reference leak and a small memory
> > leak in case a filesystem link operation returns ESTALE
> > which is pretty normal for distributed filesystems like
> > lustre, nfs and so on.
> > Free old_path in such a case.
> > 
> > [AV: there was another missing path_put() nearby - on the previous
> > goto retry]
> 
> This comment loses sense in this version because there's no previous goto retry,
> though it might not be important due to it just being a port of an upstream commit, I guess.

True, but it's good to keep history around :)

thanks for the review.

greg k-h
