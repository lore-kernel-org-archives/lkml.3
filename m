Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbaIHWz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:55:58 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53009 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754958AbaIHWz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:55:57 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Tue, 09 Sep 2014 01:15:23 +0200
Message-ID: <1899038.KOOHvy2XUu@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140908225012.GE3806@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <2588099.AI1YmNFQ25@vostro.rjw.lan> <20140908225012.GE3806@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 09, 2014 07:50:12 AM Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 09, 2014 at 12:48:28AM +0200, Rafael J. Wysocki wrote:
> > Well, not exactly from anywhere.  Just from where try_to_freeze() is called
> > I suppose?
> 
> Yeap, anywhere try_to_freeze() may be called.
> 
> > Which means that if this is a user space task, it won't to a lot before dying,
> > will it?
> 
> Userland tasks aren't likely to a lot of damages before dying but then
> again there's no guarantee.  As it currently stands, try_to_freeze()
> can be anywhere.

Well, in that case the TIF_MEMDIE test alone is not sufficient in my opinion,
because we can't guarantee that the task will not do something it was frozen
to prevent it from doing.

I'm not sure about the cgroups freezing case, however.

Rafael

