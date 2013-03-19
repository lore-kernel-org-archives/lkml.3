Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab3CSARI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:17:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53759 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab3CSARG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:17:06 -0400
Date: Mon, 18 Mar 2013 17:18:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, shangw@linux.vnet.ibm.com,
        linuxram@us.ibm.com
Subject: Re: [PATCH 1/2] driver core: remove device_add_attrs() in
 drivers/base/bus.c
Message-ID: <20130319001822.GC13502@kroah.com>
References: <1362622966-20003-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <1362622966-20003-2-git-send-email-weiyang@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362622966-20003-2-git-send-email-weiyang@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 10:22:45AM +0800, Wei Yang wrote:
> Originally, we have two functions named device_add_attrs() in
> drivers/base/bus.c and drivers/base/core.c. This will cause some confusion
> when reading the code.

Why?  It's just static functions.

> And the one in drivers/base/bus.c do the same action as device_add_attributes()
> in drivers/base/core.c. That would be better to reuse this code.

Possibly, yes, but you put the .h entry in the wrong place, thereby
exposing a previously static function to the entire kernel, which is not
good at all.  Why did you do that?  Are you now going to want to call
that function from some driver?

greg k-h
