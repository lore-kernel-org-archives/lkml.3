Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbbAZVF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:05:26 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58065 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766AbbAZVFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:05:21 -0500
Message-ID: <54C6AC0F.8030202@kernel.org>
Date: Mon, 26 Jan 2015 21:05:19 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Hartmut Knaack <knaack.h@gmx.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: ad2s1200: Fix sign extension
References: <1421968196-17193-1-git-send-email-linux@rasmusvillemoes.dk> <54C20CAF.3010901@metafoo.de>
In-Reply-To: <54C20CAF.3010901@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/15 08:56, Lars-Peter Clausen wrote:
> On 01/23/2015 12:09 AM, Rasmus Villemoes wrote:
>> The line above makes vel a 12-bit quantity (st->rx[] is u8). The
>> intention is to sign-extend vel using bit 11 as the sign bit. But
>> because of C's promotion rules "vel = (vel << 4) >> 4;" is actually a
>> no-op, since vel is promoted to int before the inner
>> shift. sign_extend32 works equally well for 8 and 16 bits types, so
>> use that.
>>
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Applied to fixes-togreg branch of iio.git.

Thanks,

Jonathan

