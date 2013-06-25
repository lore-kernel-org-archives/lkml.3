Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab3FYR3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:29:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47389 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751444Ab3FYR3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:29:52 -0400
Message-ID: <1372181390.1245.68.camel@joe-AO722>
Subject: Re: [PATCH] staging: ozwpan: Convert printk to dev_dbg()
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>, Jason Baron <jbaron@redhat.com>
Cc: Rupesh Gujare <rupesh.gujare@atmel.com>, devel@linuxdriverproject.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        shigekatsu.tateno@atmel.com
Date: Tue, 25 Jun 2013 10:29:50 -0700
In-Reply-To: <20130625170205.GA21328@kroah.com>
References: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>
	 <20130625170205.GA21328@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 10:02 -0700, Greg KH wrote:
> On Tue, Jun 25, 2013 at 05:30:02PM +0100, Rupesh Gujare wrote:
> > convert all debug messages from printk to dev_dbg() & add kernel config to
> > enable/disable these messages during compilation.

> No, just use the built-in dynamic debug code in the kernel, no need to
> provide any new macros or functions or most importantly, no new Kconfig
> options.

I think the Kconfig option is pretty poor too but a
long needed extension to dev_dbg is to enable classes
of messages by level or mask.

There are many existing macros like

#define module_dbg(level, fmt, ...)
do {
	if (level >= some_module_var)
		debug_something(...);
} while (0)

and

#define module_dbg(mask, fmt, ...)
do {
	if (mask & some_module_var)
		debug_something(...)
} while (0)

It'd be nice to consolidate those in dev_dbg

I'll get 'round to it one day if Jason doesn't.


