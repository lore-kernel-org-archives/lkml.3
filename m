Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaDKDJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 23:09:56 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:63635 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaDKDJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 23:09:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140410173616.GC6518@sirena.org.uk>
References: <1397134229-2380-1-git-send-email-harinik@xilinx.com>
	<20140410173616.GC6518@sirena.org.uk>
Date: Fri, 11 Apr 2014 08:39:54 +0530
Message-ID: <CAFcVECL-G_JPZXmzBLT_cFo3vmjYZd8xGFf-7Vv2uXWa9-O37Q@mail.gmail.com>
Subject: Re: [PATCH] spi: core: Increase timeout value
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        michals@xilinx.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Apr 10, 2014 at 11:06 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Apr 10, 2014 at 06:20:29PM +0530, Harini Katakam wrote:
>
>> Considering acceptable latencies, this timeout can be set to a large
>> value >= 1*HZ typically.
>
>> This patch adds a tolerance of 2000 msec in the core accordingly.
>
> That's too much, it's 2 seconds which gets to be incredibly painful when
> trying to debug problems - if you're sitting there waiting for a driver
> to time out some operations (and it may be more than one of them) so you
> can look at the diagnostics it can be quite aggrivating.  That's why the
> delays are related to the expected runtime for the operation.  Something
> like double the expected runtime plus something in the 100ms or so range
> perhaps?
>

OK.

> Ideally we'd use the actual speed the device set rather than the
> requested one too, that'd help.

How would you propose to do that - driver should write back actual speed set
to xfer->speed_hz?

Regards,
Harini
