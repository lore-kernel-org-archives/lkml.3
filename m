Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbaBUQ5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:57:36 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:52630 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441AbaBUQ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:57:35 -0500
Date: Fri, 21 Feb 2014 11:57:30 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Message-ID: <20140221165730.GA10929@htj.dyndns.org>
References: <1392929071-16555-5-git-send-email-tj@kernel.org>
 <5306AF8E.3080006@hurleysoftware.com>
 <20140221015935.GF6897@htj.dyndns.org>
 <5306B4DF.4000901@hurleysoftware.com>
 <20140221021341.GG6897@htj.dyndns.org>
 <5306E06C.5020805@hurleysoftware.com>
 <20140221100301.GA14653@mtj.dyndns.org>
 <53074BE4.1020307@hurleysoftware.com>
 <20140221130614.GH6897@htj.dyndns.org>
 <5307849A.9050209@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5307849A.9050209@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yo,

On Fri, Feb 21, 2014 at 11:53:46AM -0500, Peter Hurley wrote:
> Ok, I can do that. But AFAIK it'll have to be an smp_rmb(); there is
> no mb__after unlock.

We do have smp_mb__after_unlock_lock().

> [ After thinking about it some, I don't think preventing speculative
>   writes before clearing PENDING if useful or necessary, so that's
>   why I'm suggesting only the rmb. ]

But smp_mb__after_unlock_lock() would be cheaper on most popular
archs, I think.

Thanks.

-- 
tejun
