Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3EQPbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:31:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3EQPbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:31:41 -0400
Date: Fri, 17 May 2013 08:31:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
Subject: Re: [PATCH] tty: make sure a BUG is hit if tty_port will be
 destroyed before tty
Message-ID: <20130517153136.GC19541@kroah.com>
References: <5195B561.3090503@ahsoftware.de>
 <1368774728-4817-1-git-send-email-holler@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368774728-4817-1-git-send-email-holler@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 09:12:08AM +0200, Alexander Holler wrote:
> tty depends on tty_port until tty_release() was called. Make sure a BUG
> will be hit, if tty_port will be destroyed before tty.

So you want to ensure that we crash a machine?  No, please never add
BUG() statements to the kernel, unless something _really_ bad is going
to happen if we don't call it.  I never want to stop a machine from
running, do you?

I can't take this as-is, why not just fix the root problem?

thanks,

greg k-h
