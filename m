Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaHSSLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:11:36 -0400
Received: from ozlabs.org ([103.22.144.67]:51274 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbaHSSLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:11:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] params: Add a per cpu module param type
In-Reply-To: <1408461389-24163-1-git-send-email-andi@firstfloor.org>
References: <1408461389-24163-1-git-send-email-andi@firstfloor.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 20 Aug 2014 03:37:48 +0930
Message-ID: <87fvgsjqtn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:
> From: Andi Kleen <ak@linux.intel.com>
>
> This is mainly useful for simple statistic counters.
> Essentially read-only, writing only clears.

Nice...

> +#define param_check_percpu_uint(name, p) param_check_uint

This is wrong; will it even compile?  It should also do the __percpu
annotation so hopefully sparse will catch any misuses, eg:

#define param_check_percpu_uint(name, p) \
        __param_check(name, p, __percpu unsigned int)

The rest looks good, but I'll need a user :)

Cheers,
Rusty.
