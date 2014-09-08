Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaIHW3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:29:04 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56725 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755149AbaIHW3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:29:01 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Tue, 09 Sep 2014 00:48:28 +0200
Message-ID: <2588099.AI1YmNFQ25@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140908222253.GB3806@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <3827451.ToKxd7Xb2J@vostro.rjw.lan> <20140908222253.GB3806@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 09, 2014 07:22:53 AM Tejun Heo wrote:
> On Mon, Sep 08, 2014 at 11:53:34PM +0200, Rafael J. Wysocki wrote:
> > But please tell me this: If TIF_MEMDIE is set and we thaw the process,
> > can it do *anything* before dying or will it die immediately?
> 
> The task could be in freezer from anywhere and there's no limit in
> what the task may do before it eventually dies.

Well, not exactly from anywhere.  Just from where try_to_freeze() is called
I suppose?

Which means that if this is a user space task, it won't to a lot before dying,
will it?

Rafael

