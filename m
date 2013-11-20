Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3KTMsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 07:48:12 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39670 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3KTMsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 07:48:07 -0500
Date: Wed, 20 Nov 2013 13:48:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make DR6_RESERVED/DR_CONTROL_RESERVED unsigned long
Message-ID: <20131120124758.GA308@localhost.localdomain>
References: <20131119192145.GA8604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119192145.GA8604@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 08:21:45PM +0100, Oleg Nesterov wrote:
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
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Ok, I'm queuing it just to make sure it's not forgotten.

Thanks.
