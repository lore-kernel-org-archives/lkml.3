Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423157Ab3FUD4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 23:56:36 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:44187 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422992Ab3FUD4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 23:56:35 -0400
Date: Thu, 20 Jun 2013 22:56:30 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] nbd: correct disconnect behavior
To: Paul Clements <paul.clements@steeleye.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        paul.clements@steeleye.com, nbd-general@lists.sourceforge.net
References: <20130619210918.DF616222D8@clements>
In-Reply-To: <20130619210918.DF616222D8@clements> (from
	paul.clements@steeleye.com on Wed Jun 19 16:09:18 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1371786990.2776.137@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 04:09:18 PM, Paul Clements wrote:
> Currently, when a disconnect is requested by the user (via  
> NBD_DISCONNECT
> ioctl) the return from NBD_DO_IT is undefined (it is usually one of
> several error codes). This means that nbd-client does not know if a
> manual disconnect was performed or whether a network error occurred.
> Because of this, nbd-client's persist mode (which tries to reconnect  
> after
> error, but not after manual disconnect) does not always work  
> correctly.
> 
> This change fixes this by causing NBD_DO_IT to always return 0 if a  
> user
> requests a disconnect. This means that nbd-client can correctly either
> persist the connection (if an error occurred) or disconnect (if the  
> user
> requested it).
> 
> Signed-off-by: Paul Clements <paul.clements@steeleye.com>

Is _that_ what it was?

(Guy who wrote the busybox NBD client and never did quite understand  
the disconnect/reconnect behavior.)

Acked-by: Rob Landley <rob@landley.net>

Rob