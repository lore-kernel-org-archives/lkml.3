Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3LPPqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:46:42 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:55336 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3LPPqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:46:23 -0500
Date: Mon, 16 Dec 2013 10:46:11 -0500
From: Tejun Heo <tj@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ahci: bail out on ICH6 before using AHCI BAR
Message-ID: <20131216154611.GE32509@htj.dyndns.org>
References: <1387190061.9255.30.camel@x41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387190061.9255.30.camel@x41.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 11:34:21AM +0100, Paul Bolle wrote:
> The check for "combined mode" (which disables ahci support) on ICH6 is
> done after the first use of AHCI BAR. But if ahci is not enabled AHCI
> BAR is initialized to 0x00000000. (At least it is on the ICH6-M I tested
> this on. If I understand the datasheet correctly it should also be on
> ICH6R.) This apparently makes the call of
> pcim_iomap_regions_request_all() return -EINVAL. And we end up with
>     ahci: probe of 0000:00:1f.2 failed with error -22
> 
> (at warning level) in the logs.
> 
> So check for "combined mode" before calling
> pcim_iomap_regions_request_all().
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied to libata/for-3.13-fixes.

Thanks.

-- 
tejun
