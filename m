Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaE1Pcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:32:51 -0400
Received: from ns.horizon.com ([71.41.210.147]:22422 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753573AbaE1Pcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:32:50 -0400
Date: 28 May 2014 11:32:49 -0400
Message-ID: <20140528153249.18014.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: herbert@gondor.apana.org.au, JBeulich@suse.com, linux@horizon.com,
        tim.c.chen@linux.intel.com
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink K_table
Cc: linux-kernel@vger.kernel.org, sandyw@twitter.com
In-Reply-To: <20140528144000.28686.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Um, yeah, I just noticed the problem with that patch: half of the numbers
in that table are 33 bits, and cause a pile of warnings (not errors,
unfortunately!) from gas that scrolled by when I wasn't looking.

Logically, there should be no need for 33-bit values; they should all be
reducible modulo the polynomial.  But that is going to take a slightly
larger change.
