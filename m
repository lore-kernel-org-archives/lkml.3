Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaFKNLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 09:11:44 -0400
Received: from imap.thunk.org ([74.207.234.97]:33381 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbaFKNLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 09:11:43 -0400
Date: Wed, 11 Jun 2014 09:11:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
Message-ID: <20140611131140.GD23110@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140611020835.GA23110@thunk.org>
 <20140611035806.9237.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611035806.9237.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 11:58:06PM -0400, George Spelvin wrote:
> You can forbid underflows, but the code doesn't forbid overflows.
> 
> 1. Assume the entropy count starts at 512 bytes (input pool full)
> 2. Random writer mixes in 20 bytes of entropy into the input pool.
> 2a. Input pool entropy is, however, capped at 512 bytes.
> 3. Random extractor extracts 32 bytes of entropy from the pool.
>    Succeeds because 32 < 512.  Pool is left with 480 bytes of
>    entropy.
> 3a. Random extractor decrements pool entropy estimate to 480 bytes.
>     This is accurate.
> 4. Random writer credits pool with 20 bytes of entropy.
> 5. Input pool entropy is now 480 bytes, estimate is 500 bytes.

Good point, that's a potential problem, although messing up the
accounting betewen 480 and 500 bytes is not nearly as bad as messing
up 0 and 20.

It's not something where if the changes required massive changes, that
I'd necessarily feel the need to backport them to stable.  It's a
certificational weakness, but it's a not disaster.

						- Ted
