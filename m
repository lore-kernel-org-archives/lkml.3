Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbaESTwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:52:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48919 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaESTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:52:49 -0400
Date: Mon, 19 May 2014 22:52:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Matlack <matlackdavid@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        Lior Dotan <liodot@gmail.com>, linux-kernel@vger.kernel.org,
        charrer@alacritech.com
Subject: Re: [PATCH 2/2] staging: slicoss: remove slic_reg_params struct
Message-ID: <20140519195233.GX15585@mwanda>
References: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
 <1400385604-21086-3-git-send-email-matlackdavid@gmail.com>
 <20140519092119.GT15585@mwanda>
 <CANoiuGLjBwitL_==2xVQ_021p=3uOCf2qwqWYdrmiRE7rQM0FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANoiuGLjBwitL_==2xVQ_021p=3uOCf2qwqWYdrmiRE7rQM0FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 08:57:49AM -0700, David Matlack wrote:
> On Mon, May 19, 2014 at 2:21 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > Looking at the patch, this looks like a bugfix but the changelog doesn't
> > give any clues.
> 
> Yeah this isn't a bug fix.
> 
> The only member of struct slic_reg_params that was in use was fail_on_bad_eeprom
> (implicitly set to zero by alloc_etherdev -> kzalloc). Since the previous patch
> in this series fixes the eeprom checksum, we can remove this struct entirely.
> 
> If we do want the feature of ignoring a corrupt/bad eeprom, a module param
> would work better anyway.

I think we are talking at cross purposes.

-               if ((!card->config.EepromValid) &&
-                   (adapter->reg_params.fail_on_bad_eeprom)) {
+               if (!card->config.EepromValid) {
                        slic_reg64_write(adapter, &slic_regs->slic_isp, 0,

In the original code then this if condition is never true because
->fail_on_bad_eeprom is zero.

You are saying that this condition is still not true because
->EepromValid is true now you fixed the checksum code.  I am saying
that *sometimes* it *could* be true if the eeprom is corrupt.

You have to understand that I review a lot of staging patches every day.
Most patches try to remove struct members but the code should still work
exactly as it did before (a clean up).  Some patches remove struct
members and the behavior changes.  Hopefully it's deliberate and the
changelog mentions that it is a bug fix.  If it changes the run time,
and not deliberately then that's a bug.

This code, your code, is a bugfix.  Thanks.  :)  Next time mention then
that you fixing stuff in changelog.

regards,
dan carpenter
