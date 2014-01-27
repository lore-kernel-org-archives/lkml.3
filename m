Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaA0Owi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:52:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbaA0Owh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:52:37 -0500
Date: Mon, 27 Jan 2014 09:52:09 -0500
From: Dave Jones <davej@redhat.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when
 seting kernel nodes to unhotpluggable.
Message-ID: <20140127145209.GA18016@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Tang Chen <tangchen@cn.fujitsu.com>,
	David Rientjes <rientjes@google.com>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
	zhangyanfei@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
 <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com>
 <20140123061343.GB15206@redhat.com>
 <alpine.DEB.2.02.1401222214290.8088@chino.kir.corp.google.com>
 <20140123065824.GA17684@redhat.com>
 <20140123223136.GA18468@redhat.com>
 <52E60ABF.9020400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E60ABF.9020400@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 03:29:03PM +0800, Tang Chen wrote:

 > > Some build tests show..
 > >
 > > MAXSMP ( NODESHIFT=10 ) : Bug
 > > NRCPUS=4&  NODESHIFT=10 : Bug
 > > NRCPUS=4&  NODESHIFT=1 : no bug
 > >
 > >
 > > The middle config test was accidental, I hadn't realised disabling MAXSMP
 > > wouldn't reset NODESHIFT to something sane.
 > >
 > > I'll start bisecting, as MAXSMP worked fine until a few days ago.
 > 
 > Hi Dave,
 > 
 > I didn't reproduce this bug. Would you please share the bisect result ?

The bisect pointed at something completely unrelated, and then when I tried 
again on git HEAD, I couldn't reproduce it.. 
If I manage to get it happening again I'll look into it more, but for now
it seems to have gone into hiding.

	Dave
