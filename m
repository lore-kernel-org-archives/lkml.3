Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab3BXPPs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 10:15:48 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57341 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223Ab3BXPPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 10:15:46 -0500
Message-ID: <1361718906.2908.48.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH] ima: fix part_pack_uuid() build error
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: David Rientjes <rientjes@google.com>, James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>, axboe <axboe@kernel.dk>
Date: Sun, 24 Feb 2013 10:15:06 -0500
In-Reply-To: <5127E111.6030605@infradead.org>
References: <1361562413.2908.22.camel@falcor1.watson.ibm.com>
	 <5127E111.6030605@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022415-7182-0000-0000-0000057A7E7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 13:20 -0800, Randy Dunlap wrote:
> On 02/22/13 11:46, Mimi Zohar wrote:
> > Fix a build error when CONFIG_BLOCK is not enabled by defining
> > a wrapper called ima_part_pack_uuid().  The wrapper returns
> > -EINVAL, when CONFIG_BLOCK is not defined.
> 
> Some function wrapper for the case of BLOCK not enabled should be handled
> where the function is defined, not where it is called.
> That's how it is usually done in Linux.

Ok, I've renamed the wrapper from ima_part_pack_uuid() to
blk_part_pack_uuid() and moved it to linux/genhd.h

thanks,

Mimi





