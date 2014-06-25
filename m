Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbaFYNT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:19:27 -0400
Received: from mout.gmx.net ([212.227.15.18]:55259 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbaFYNTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:19:25 -0400
MIME-Version: 1.0
In-Reply-To: <1403690595.20275.14.camel@sauron.fi.intel.com>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
	<alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
	<1403677528.7903.103.camel@sauron.fi.intel.com>
	<CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
	<1403690595.20275.14.camel@sauron.fi.intel.com>
Date: Wed, 25 Jun 2014 15:19:23 +0200
Message-ID: <CABhLV03r7FmbX03V-pWtKFppmNe_GjHx4vXVKSPVw6t7bohtnA@mail.gmail.com>
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
From: Thomas Knauth <thomas.knauth@gmx.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-Provags-ID: V03:K0:MbJPBKz7x1Vu2U4nst48XjLvFdChOviKr715TtqSLX2PfSKQr9x
 KaAhYY+nC5KIZ+30VslaJ8gKAm07cTgWlcX2ljc2iRtXwwrLJ5sIcmlPLHsxbwYk4XfirXr
 Vlh+bL7r/PldYRDd3+gNhJLi26QfTE07eck7KISUGPs12L4VUQ9Czo8XmfTne+u2mP7hjiL
 URjIF/qw73H9XsGbNkiMQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 12:03 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Wed, 2014-06-25 at 10:25 +0200, Thomas Knauth wrote:
>> On Wed, Jun 25, 2014 at 8:25 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
>> > Plus some explanations WRT why proc-based interface and what would be
>> > the alternatives, what if tomorrow we want to extend the functionality
>> > and drop caches only for certain file range, is this only for regular
>> > files or also for directories, why posix_fadvice(DONTNEED) is not
>> > sufficient.
>>
>> I suggested the idea originally. Let me address each of your questions in turn:
>
> I'd also be interested to see some analysis about path-based interface
> vs. file descriptor-base interface. What are cons and pros. E.g. if my
> path is a symlink, with path-based interface it is not obvious whether I
> drop caches for the symlink itself or caches of the target.

Haven't considered this case. It feels like the sensible thing to do
here is dereference the link and drop whatever it is pointing to.
