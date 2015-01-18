Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbbARSeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 13:34:23 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64606 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbbARSeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 13:34:20 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: mjg59@srcf.ucam.org, pali.rohar@gmail.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, A.Sloman@cs.bham.ac.uk,
        computersforpeace@gmail.com
Subject: Re: [PATCH] dell-laptop: use dedicated sysfs file for ALS
Date: Sun, 18 Jan 2015 19:34:17 +0100
Message-ID: <1663320.Wk1Y30OHLH@xps13>
In-Reply-To: <20150118180821.GB56582@vmdeb7>
References: <1421244357-31103-1-git-send-email-gabriele.mzt@gmail.com> <9352624.oIKUSW0aDp@xps13> <20150118180821.GB56582@vmdeb7>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 January 2015 10:08:21 Darren Hart wrote:
> On Wed, Jan 14, 2015 at 03:07:21PM +0100, Gabriele Mazzotta wrote:
> > Hi,
> > 
> > I decided to remove "als" from input_triggers and created a dedicated
> > sysfs file for it. Having it there was wrong and misleading.
> > I also updated the documentation to reflect this change and fixed the
> > wrong description of als_setting, now used for als_enabled.
> 
> Given this is a significant functional change, as opposed to a bug fix, I'm
> leaning toward reverting the original and adding back the corrected version to
> 3.20. I'm going to look at the total impact first - let me know if you have a
> strong argument one way or the other.

I'm not against this decision.
If you do, please remember to also revert the commit that added the
documentation.

> > Is returning -ENODEV only when writing to als_enabled the right thing
> > to do or should it be returned also when reading als_enabled?
> 
> Why would the als_enabled file exist if it would return ENODEV? If it shouldn't,
> then returning ENODEV in both cases would be the right thing to do as there is
> an error present.

I'd say it makes sense not to create it when not neeeded.
Creating the file conditionally probably requires more changes than what
you'd like to see at this stage, so this would be another argument
supporting the revert.
