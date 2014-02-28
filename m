Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaB1WqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:46:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaB1WqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:46:03 -0500
Date: Fri, 28 Feb 2014 14:47:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: dirk.brandewie@gmail.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, gf435@gmx.net, bp@alien8.de,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH] intel_pstate: Change busy calculation to use fixed point
 math.
Message-ID: <20140228224741.GA31233@kroah.com>
References: <20140219224752.GA370@kroah.com>
 <1393353337-19778-1-git-send-email-dirk.j.brandewie@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393353337-19778-1-git-send-email-dirk.j.brandewie@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 10:35:37AM -0800, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> 
> Commit fcb6a15c2e Take core C0 time into account for core busy calculation.
> 
> Introduced a regression on some processor SKUs supported by
> intel_pstate. This was caused by the truncation caused by using
> integer math to calculate core busy and C0 percentages.
> 
> On a i7-4770K processor operating at 800Mhz going to 100% utilization
> the percent busy of the CPU using integer math is 22% it actually is
> 22.85%.  This value scaled to the current frequency returned 97 which
> the PID interpreted as no error and did not adjust the P state.
> 
> Tested on i7-4770K, i7-2600, i5-3230M
> 
> References:
>    https://lkml.org/lkml/2014/2/19/626
>    https://bugzilla.kernel.org/show_bug.cgi?id=70941
> 
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

Thanks, this fixed the issue for me:

Tested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
