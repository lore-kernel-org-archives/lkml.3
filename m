Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3BUJLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 04:11:02 -0500
Received: from www.linutronix.de ([62.245.132.108]:46860 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab3BUJK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 04:10:59 -0500
Date: Thu, 21 Feb 2013 10:10:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] idr: explain WARN_ON_ONCE() on negative IDs out-of-range
 ID
In-Reply-To: <20130220233557.GM3570@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1302211010350.22263@ionos>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com> <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com> <512522CF.1020901@oracle.com> <20130220210116.GD3570@htj.dyndns.org> <20130220132300.ccffde44.akpm@linux-foundation.org>
 <20130220213701.GE3570@htj.dyndns.org> <20130220140551.8017e795.akpm@linux-foundation.org> <20130220220823.GH3570@htj.dyndns.org> <20130220224019.GI3570@htj.dyndns.org> <20130220232412.GL3570@htj.dyndns.org> <20130220233557.GM3570@htj.dyndns.org>
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

> Until recently, when an negative ID is specified, idr functions used
> to ignore the sign bit and proceeded with the operation with the rest
> of bits, which is bizarre and error-prone.  The behavior recently got
> changed so that negative IDs are treated as invalid but we're
> triggering WARN_ON_ONCE() on negative IDs just in case somebody was
> depending on the sign bit being ignored, so that those can be detected
> and fixed easily.
> 
> We only need this for a while.  Explain why WARN_ON_ONCE()s are there
> and that they can be removed later.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by : Thomas Gleixner <tglx@linutronix.de>
