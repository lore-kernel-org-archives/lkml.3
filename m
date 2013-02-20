Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab3BTXIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:08:05 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:42570 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab3BTXID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:08:03 -0500
Date: Wed, 20 Feb 2013 15:07:58 -0800
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ out-of-range ID
Message-ID: <20130220230758.GK3570@htj.dyndns.org>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com>
 <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com>
 <512522CF.1020901@oracle.com>
 <20130220210116.GD3570@htj.dyndns.org>
 <20130220132300.ccffde44.akpm@linux-foundation.org>
 <20130220213701.GE3570@htj.dyndns.org>
 <20130220140551.8017e795.akpm@linux-foundation.org>
 <20130220220823.GH3570@htj.dyndns.org>
 <20130220224019.GI3570@htj.dyndns.org>
 <alpine.LFD.2.02.1302202358220.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1302202358220.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On Thu, Feb 21, 2013 at 12:01:07AM +0100, Thomas Gleixner wrote:
> idr_find() should simply return NULL, if "id < 0". Is it that hard?

It already does but w/ WARN_ON_ONCE().  The WARN_ON_ONCE() is there
mostly as a transitional precaution.  As the previous idr_find()
behavior was extremely weird, just in case someone was depending on
ignoring the msb for example, it would be nice to be able to identify
the ones which are passing in negative ids, at least for a release
cycle or two.

Thanks.

-- 
tejun
