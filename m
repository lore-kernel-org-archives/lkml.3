Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbaBRRGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:06:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbaBRRGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:06:06 -0500
Date: Tue, 18 Feb 2014 09:07:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: devel@driverdev.osuosl.org, swetland@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: android: binder: use stack for locally used
 variable
Message-ID: <20140218170730.GA32227@kroah.com>
References: <1392722606-965-1-git-send-email-sj38.park@gmail.com>
 <1392722606-965-2-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392722606-965-2-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 08:23:26PM +0900, SeongJae Park wrote:
> The variable `binder_debugfs_dir_entry_root` is declared as static
> global variable although it is accessed from init function only. Declare
> it as init function's local variable because it would be better to read
> and memory efficiency.

Are you sure?  You now just lost that pointer and it can never be freed.

Not that it ever was, but before it was obvious as to what would need to
be done if the module could ever be made to be unloaded...

As it is, this code is fine, I can't take this patch.

greg k-h
