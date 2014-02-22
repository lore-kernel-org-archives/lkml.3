Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaBVOjH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 09:39:07 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:60671 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaBVOjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 09:39:05 -0500
Date: Sat, 22 Feb 2014 09:38:59 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Message-ID: <20140222143859.GD12830@htj.dyndns.org>
References: <20140221021341.GG6897@htj.dyndns.org>
 <5306E06C.5020805@hurleysoftware.com>
 <20140221100301.GA14653@mtj.dyndns.org>
 <53074BE4.1020307@hurleysoftware.com>
 <20140221130614.GH6897@htj.dyndns.org>
 <5307849A.9050209@hurleysoftware.com>
 <20140221165730.GA10929@htj.dyndns.org>
 <5307DAC9.2020103@hurleysoftware.com>
 <20140221231833.GC12830@htj.dyndns.org>
 <5307E550.4040004@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5307E550.4040004@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Feb 21, 2014 at 06:46:24PM -0500, Peter Hurley wrote:
> It's a long story but the short version is that
> Documentation/memory-barriers.txt recently was overhauled to reflect
> what cpus actually do and what the different archs actually
> deliver.
> 
> Turns out that unlock + lock is not guaranteed by all archs to be
> a full barrier. Thus the smb_mb__after_unlock_lock().
> 
> This is now all spelled out in memory-barriers.txt under the
> sub-heading "IMPLICIT KERNEL MEMORY BARRIERS".

So, that one is for unlock/lock sequence, not smp_mb__after_unlock().
Urgh... kinda dislike adding smp_rmb() there as it's one of the
barriers which translate to something weighty on most, if not all,
archs.

Thanks.

-- 
tejun
