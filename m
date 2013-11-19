Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab3KSTVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:21:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab3KSTVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:21:30 -0500
Date: Tue, 19 Nov 2013 20:22:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make DR6_RESERVED/DR_CONTROL_RESERVED unsigned
	long
Message-ID: <20131119192248.GA8608@redhat.com>
References: <20131119192145.GA8604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119192145.GA8604@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19, Oleg Nesterov wrote:
>
> DR6_RESERVED and DR_CONTROL_RESERVED are used to clear the unwanted
> bits in the "unsigned long" data, but "ulong &= ~int" also clears the
> upper bits that are not specified in mask.
>
> This is actually fine, dr6[32:63] are reserved, but this is not clear
> so it would be better to make them "unsigned long" to cleanup the code.
>
> However, depending on sizeof(long), DR6_RESERVED should be either
> 0xFFFF0FF0 or 0xFFFFFFFF_FFFF0FF0, so this patch redefines them as
> (~ 32_bit_mask UL) to avoid ifdef's.

Peter, iirc you acked this patch, but its seems it was lost.

Oleg.

