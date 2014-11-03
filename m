Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913AbaKCXym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:54:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaKCXyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:54:39 -0500
Date: Mon, 3 Nov 2014 15:54:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next V3] mei: add reference counting for me clients
Message-ID: <20141103235439.GA26158@kroah.com>
References: <1415004125-5467-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415004125-5467-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 10:42:05AM +0200, Tomas Winkler wrote:
> To support dynamic addition/remove we add reference
> counter.

What is keeping two different threads / cpus from grabbing a reference
at the same time the other one is dropping it?

You have a list here, with no locking, right?  You also don't have any
locking for your kref, which isn't good at all...

Please audit and fix up.

thanks,

greg k-h
