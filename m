Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965011Ab3FTA7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 20:59:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46808 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934734Ab3FTA7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 20:59:32 -0400
Date: Wed, 19 Jun 2013 17:59:28 -0700 (PDT)
Message-Id: <20130619.175928.1277008545805789566.davem@davemloft.net>
To: steve.moorby@ntlworld.com
Cc: sasha.levin@oracle.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, jiri@resnulli.us,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net/x25: fix address parsing bug in
 x25_parse_address_block.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371673956-471-1-git-send-email-steve.moorby@ntlworld.com>
References: <1371673956-471-1-git-send-email-steve.moorby@ntlworld.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Moorby <steve.moorby@ntlworld.com>
Date: Wed, 19 Jun 2013 21:32:36 +0100

> This problem was discovered when a linux box was incorrectly rejecting
> calls from some X.25 equipment.  The problem was diagnosed to an incorrect
> address length calculation in 'x25_parse_address_block', the calculation
> did not account for the address digits being BCD encoded.  The correct
> calculation is already performed on line 155.
> 
> Patched on linux-next 18-Jun-2013
> Tested on 2.6.32-45-generic
> 
> Signed-off-by: Stephen Moorby <steve.moorby@ntlworld.com>

This change has two problems:

1) If there is existing code that does the calculation correctly, don't
   get creative and express the calculation differently than the existing
   code.

2) If there are two places doing the same thing, write a helper function
   that does it in one place.

The exact reason this bug exists is because of code duplication, you are
making it even worse by writing the same calculation two different ways.

Please fix this up and resubmit, thanks.

