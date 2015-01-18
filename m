Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbbARSIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 13:08:25 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36874 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbbARSIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 13:08:23 -0500
Date: Sun, 18 Jan 2015 10:08:21 -0800
From: Darren Hart <dvhart@infradead.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: mjg59@srcf.ucam.org, pali.rohar@gmail.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, A.Sloman@cs.bham.ac.uk,
        computersforpeace@gmail.com
Subject: Re: [PATCH] dell-laptop: use dedicated sysfs file for ALS
Message-ID: <20150118180821.GB56582@vmdeb7>
References: <1421244357-31103-1-git-send-email-gabriele.mzt@gmail.com>
 <9352624.oIKUSW0aDp@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9352624.oIKUSW0aDp@xps13>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 03:07:21PM +0100, Gabriele Mazzotta wrote:
> Hi,
> 
> I decided to remove "als" from input_triggers and created a dedicated
> sysfs file for it. Having it there was wrong and misleading.
> I also updated the documentation to reflect this change and fixed the
> wrong description of als_setting, now used for als_enabled.

Given this is a significant functional change, as opposed to a bug fix, I'm
leaning toward reverting the original and adding back the corrected version to
3.20. I'm going to look at the total impact first - let me know if you have a
strong argument one way or the other.

> 
> Is returning -ENODEV only when writing to als_enabled the right thing
> to do or should it be returned also when reading als_enabled?

Why would the als_enabled file exist if it would return ENODEV? If it shouldn't,
then returning ENODEV in both cases would be the right thing to do as there is
an error present.

-- 
Darren Hart
Intel Open Source Technology Center
