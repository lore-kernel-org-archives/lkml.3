Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaECQBJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 12:01:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60366 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855AbaECQBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 12:01:07 -0400
Date: Sat, 3 May 2014 18:01:02 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iio: fix possible buffer overflow
Message-ID: <20140503160101.GA4707@piout.net>
References: <1399070450-23391-1-git-send-email-alexandre.belloni@free-electrons.com>
 <5364C0E6.4020401@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5364C0E6.4020401@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 at 11:11:50 +0100, Jonathan Cameron wrote :
> On 02/05/14 23:40, Alexandre Belloni wrote:
> >Found using smatch:
> >drivers/iio/industrialio-core.c:719 iio_device_add_info_mask_type() error:
> >buffer overflow 'iio_chan_info_postfix' 17 <= 63
> >
> >It was probably never hit because the info_mask_* members are filled by using
> >the BIT() macro with values from the iio_chan_info_enum enum that also serve as
> >the index of the iio_chan_info_postfix array.
> >
> >Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> See
> ef4b4856593fc3d9d169bededdaf7acf62f83a52
> iio:core: Fix bug in length of event info_mask and catch unhandled bits set in masks.
> 
> Which fixes the same issue in a slightly different way.
> 
> Pretty recent patch though and this was there for ages before that.
> Better to have two fixes than none.
> 

Yeah, I missed your patch and it didn't hit Linus' tree yet. Sorry about
the noise, next time I'll try to remember to check your tree.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
