Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab3GUUSA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 16:18:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:3760 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822Ab3GUUR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 16:17:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,714,1367996400"; 
   d="scan'208";a="271280922"
Message-ID: <51EC41F5.4040808@linux.intel.com>
Date: Sun, 21 Jul 2013 13:17:57 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] x86 fixes for 3.11-rc2
References: <20130720122504.25856.qmail@science.horizon.com>
In-Reply-To: <20130720122504.25856.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2013 05:25 AM, George Spelvin wrote:
> It's marginal with only two call sites, but would it be worth factoring
> out the write-back function?  Something like this (untested) patch.
> It definitely makes the generated assembly cleaner.
> 
> (Signed-off-by: George Spelvin <linux@horizon.com> if you want it.)

Two call sites, statistically "never" executed, really doesn't justify
adding a new assembly function.  I was considering making a C wrapper,
though... I would also like to change these to using rdmsrl/wrmsrl.

	-hpa


