Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaE1UrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:47:21 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:43380 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaE1UrT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 28 May 2014 16:47:19 -0400
Message-Id: <5386596402000078000B51F8@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 28 May 2014 21:47:16 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <herbert@gondor.apana.org.au>, <linux@horizon.com>,
        <tim.c.chen@linux.intel.com>
Cc: <sandyw@twitter.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink
 K_table
References: <20140528144000.28686.qmail@ns.horizon.com>
In-Reply-To: <20140528144000.28686.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "George Spelvin" <linux@horizon.com> 05/28/14 4:40 PM >>>
>Jan: Is support for SLE10's pre-2.18 binutils still required?
>Your PEXTRD fix was only a year ago, so I expect, but I wanted to ask.

I'd much appreciate if I would be able to build the kernel that way for another while.

>Two other minor additional changes:
>
>1. The current code unnecessarily puts the table in the read-write
   >.data section.  Moved to .text.

Putting data into .text seems wrong - it should go into .rodata.

Jan

