Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaERQXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 12:23:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50297 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaERQXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 12:23:09 -0400
Date: Sun, 18 May 2014 19:22:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Masood Mehmood <ody.guru@gmail.com>
Subject: Re: [PATCH] Fix for possible null pointer dereference in node.c
Message-ID: <20140518162253.GM15585@mwanda>
References: <1400190833-27882-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140515224327.GA16255@mwanda>
 <CAFo99gYEf6GrAjuWNc5+DEEuBV82eejRuy7QtiJuLD+sRccLRA@mail.gmail.com>
 <20140517185615.GB15585@mwanda>
 <CAFo99gbnN8j8WgY3O1eDgkpkmJU11X8-9cCU_0_s7TRN8wNW+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gbnN8j8WgY3O1eDgkpkmJU11X8-9cCU_0_s7TRN8wNW+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 05:49:52PM +0200, Rickard Strandqvist wrote:
> Hi
> 
> When I run cppcheck find the about 5,000 errors, of these, I selected
> the 100 most serious and has made patches. But my ability to immerse
> myself in each failure has been limited unfortunately.
> 

I am familiar with that feeling.  ;)

With Smatch, I ignore inconsistent NULL checking like this when we know
that the parameter is always non-NULL.  It was just too much hassle to
deal with.

These days I tend to report more bugs instead of fixing them myself.  I
run on linux-next and complain to the original author as soon as the
buggy code is merged.  If the code is old, then my experience is that no
one will fix it.

Also 5000 inconsistent NULL checks seems like too high of a figure.  For
my inconsistent NULL checks I get 215 of these warnings:

	sound/i2c/other/ak4xxx-adda.c:808 build_adc_controls()
	error: we previously assumed 'ak->adc_info' could be null (see line 789)

And 75 of these:

	fs/efs/inode.c:298 efs_map_block()
	warn: variable dereferenced before check 'bh' (see line 292)

regards,
dan carpenter

