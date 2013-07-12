Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362Ab3GLURO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 16:17:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55230 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965283Ab3GLURM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 16:17:12 -0400
Date: Fri, 12 Jul 2013 21:17:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, Stable <stable@vger.kernel.org>
Message-ID: <20130712201703.GB7729@decadent.org.uk>
References: <1373637292-25855-1-git-send-email-kys@microsoft.com>
 <1373637375-25936-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373637375-25936-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 1/2] Drivers: hv: balloon: Fix a bug in the hot-add code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 06:56:14AM -0700, K. Y. Srinivasan wrote:
> As we hot-add 128 MB chunks of memory, we wait to ensure that the memory
> is onlined before attempting to hot-add the next chunk. If the udev rule for
> memory hot-add is not executed within the allowed time, we would rollback the
> state and abort further hot-add. Since the hot-add has succeeded and the only
> failure is that the memory is not onlined within the allowed time, we should not
> be rolling back the state. Fix this bug.
[...]
>  		/*
>  		 * Wait for the memory block to be onlined.
>  		 */
> -		t = wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
> -		if (t == 0) {
> -			pr_info("hot_add memory timedout\n");
> -			has->ha_end_pfn -= HA_CHUNK;
> -			has->covered_end_pfn -=  processed_pfn;
> -			break;
> -		}
> +		wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
>  
>  	}
>  

Well now it might look like a bug that you don't test the result
of wait_for_completion_timeout().  Maybe update the comment to
explain why it's OK to continue anyway?

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
