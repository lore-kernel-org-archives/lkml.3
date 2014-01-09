Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaAIEda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 23:33:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaAIEd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 23:33:27 -0500
Date: Wed, 8 Jan 2014 20:33:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Wang YanQing <udknight@gmail.com>, jslaby@suse.cz, airlied@redhat.com,
        akpm@linux-foundation.org, kilobyte@angband.pl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2]vt: fix potential dual con_driver register for
 conswitchp
Message-ID: <20140109043349.GB28887@kroah.com>
References: <20131230032118.GB4424@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131230032118.GB4424@udknight>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 11:21:18AM +0800, Wang YanQing wrote:
> We should check whether conswitchp is registered before
> add it to registered_con_driver in con_init, or it will
> cause dual con_driver register for conswitchp.
> 
> Although I haven't met it in reality, but I think it could
> happen for Embeded devices, who register platform con_driver
> earlier than call con_init.

Does that happen on those systems?  Let's not add code that's never
going to be use, and is not needed, right?

thanks,

greg k-h
