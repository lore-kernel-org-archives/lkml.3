Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3LMQyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:54:03 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:34262 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab3LMQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:53:59 -0500
Date: Fri, 13 Dec 2013 17:53:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-i2c@vger.kernel.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wolfram@the-dreams.de>
Subject: Re: [PATCH] i2c: Add message transfer tracepoints for I2C and SMBUS
Message-ID: <20131213175350.0c4a95d5@endymion.delvare>
In-Reply-To: <3708.1386950736@warthog.procyon.org.uk>
References: <20131213163349.4bc686c0@endymion.delvare>
	<20131213142627.4014.42860.stgit@warthog.procyon.org.uk>
	<3708.1386950736@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013 16:05:36 +0000, David Howells wrote:
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > One significant difference between both implementations is that the old
> > one logs before the actual transfer, while yours logs afterward. While I
> > understand this allows you to log the result of the transfer, this also
> > means you'll miss the log if the actual transaction locks the system
> > (we've seen this before.) Something to think about...
> 
> I could split each into three messages:
> 
> 	- Write request (has params & data buffer)
> 	- Read request (has params but no data buffer)
> 	- Read reply (has data buffer only)
> 
> It will make the transfer functions more complex, though, and will mean that,
> for i2c, you won't get all the replies to the messages in a batch in with the
> requests.  I can also label the messages with the index number.  Mostly I
> suspect this won't be a problem.

Fine with me, we can leave it as is and revisit if it ever is a
problem in practice.

-- 
Jean Delvare
