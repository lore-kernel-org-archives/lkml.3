Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3LMRFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:05:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab3LMRFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:05:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20131213104806.4fb56012@gandalf.local.home>
References: <20131213104806.4fb56012@gandalf.local.home> <20131213142627.4014.42860.stgit@warthog.procyon.org.uk> <20131213163349.4bc686c0@endymion.delvare>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: dhowells@redhat.com, Jean Delvare <khali@linux-fr.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wolfram@the-dreams.de>
Subject: Re: [PATCH] i2c: Add message transfer tracepoints for I2C and SMBUS
Date: Fri, 13 Dec 2013 17:04:14 +0000
Message-ID: <22364.1386954254@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> wrote:

> > Would it be possible to print this as a string rather than a number?
> > The protocol numbers are completely arbitrary, so the reader would have
> > to open i2c.h each time to figure out what is what.
> 
> That can be done in the TP_printk() with:
> 
> 	".. %s ..", ..,
> 	__print_symbolic(__entry->protocol,
> 		{ I2C_SMBUS_QUICK	,	"QUICK"	},
> 		{ I2C_SMBUS_BYTE	,	"BYTE"	},
> 		{ I2C_SMBUS_BYTE_DATA	,	"BYTE_DATA" },
> 		[...]
> 		{ I2C_SMBUS_I2C_BLOCK_DATA,	"I2C_BLOCK_DATA"}), ...

What happens if the number isn't in the table?

David
