Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab3BTXLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:11:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:43592 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3BTXLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:11:15 -0500
Date: Thu, 21 Feb 2013 00:11:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ out-of-range ID
In-Reply-To: <20130220230758.GK3570@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1302210010250.22263@ionos>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com> <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com> <512522CF.1020901@oracle.com> <20130220210116.GD3570@htj.dyndns.org> <20130220132300.ccffde44.akpm@linux-foundation.org>
 <20130220213701.GE3570@htj.dyndns.org> <20130220140551.8017e795.akpm@linux-foundation.org> <20130220220823.GH3570@htj.dyndns.org> <20130220224019.GI3570@htj.dyndns.org> <alpine.LFD.2.02.1302202358220.22263@ionos> <20130220230758.GK3570@htj.dyndns.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Tejun Heo wrote:

> Hello, Thomas.
> 
> On Thu, Feb 21, 2013 at 12:01:07AM +0100, Thomas Gleixner wrote:
> > idr_find() should simply return NULL, if "id < 0". Is it that hard?
> 
> It already does but w/ WARN_ON_ONCE().  The WARN_ON_ONCE() is there
> mostly as a transitional precaution.  As the previous idr_find()
> behavior was extremely weird, just in case someone was depending on
> ignoring the msb for example, it would be nice to be able to identify
> the ones which are passing in negative ids, at least for a release
> cycle or two.

No objection, but please add this to the changelog and the comment.

Thanks,

	tglx
