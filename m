Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3LMQFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:05:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab3LMQFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:05:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20131213163349.4bc686c0@endymion.delvare>
References: <20131213163349.4bc686c0@endymion.delvare> <20131213142627.4014.42860.stgit@warthog.procyon.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: dhowells@redhat.com, linux-i2c@vger.kernel.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wolfram@the-dreams.de>
Subject: Re: [PATCH] i2c: Add message transfer tracepoints for I2C and SMBUS
Date: Fri, 13 Dec 2013 16:05:36 +0000
Message-ID: <3708.1386950736@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare <khali@linux-fr.org> wrote:

> One significant difference between both implementations is that the old
> one logs before the actual transfer, while yours logs afterward. While I
> understand this allows you to log the result of the transfer, this also
> means you'll miss the log if the actual transaction locks the system
> (we've seen this before.) Something to think about...

I could split each into three messages:

	- Write request (has params & data buffer)
	- Read request (has params but no data buffer)
	- Read reply (has data buffer only)

It will make the transfer functions more complex, though, and will mean that,
for i2c, you won't get all the replies to the messages in a batch in with the
requests.  I can also label the messages with the index number.  Mostly I
suspect this won't be a problem.

David
