Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab3JQROn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:14:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3JQROm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:14:42 -0400
Date: Thu, 17 Oct 2013 10:14:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: channing <chao.bi@intel.com>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n_gsm: race between ld close and gsmtty open
Message-ID: <20131017171441.GA27850@kroah.com>
References: <1381980550.19582.8.camel@bichao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381980550.19582.8.camel@bichao>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 11:29:10AM +0800, channing wrote:
> 
> ttyA has ld associated to n_gsm, when ttyA is closing, it triggers
> to release gsmttyB's ld data dlci[B], then race would happen if gsmttyB
> is opening in parallel.
> 
> Here are some of race cases we found recently in test:

Are these still an issue with 3.12-rc4?  Lots of pty rework has gone
into there that should help to resolve some of these problems.

thanks,

greg k-h
