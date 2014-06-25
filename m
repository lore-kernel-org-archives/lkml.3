Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbaFYNXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:23:47 -0400
Received: from mout.gmx.net ([212.227.17.21]:60140 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbaFYNXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:23:46 -0400
MIME-Version: 1.0
In-Reply-To: <1403690184.20275.11.camel@sauron.fi.intel.com>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
	<alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
	<1403677528.7903.103.camel@sauron.fi.intel.com>
	<CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
	<1403690184.20275.11.camel@sauron.fi.intel.com>
Date: Wed, 25 Jun 2014 15:23:42 +0200
Message-ID: <CABhLV02COaH=qP=Snd7YJtcVOvm9NTmY58QuiTQoPZxH3NemPQ@mail.gmail.com>
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
From: Thomas Knauth <thomas.knauth@gmx.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-Provags-ID: V03:K0:Gvm7yI5Mn9g4qmkZbiQ0cnsctcqLw+wbfLGtvWYre/sb6GIh7XF
 s6bBg3OjFp7WP8VwEYrge6+aoDMVnHMv9cXDWBoD3LgvW12QYUa/EY1IhLbjCSFuaEwmVq1
 tyhQ2MBnqRQogbdma7jN9khqTryS2yDbX7RD+6ch0R4h2GaEEIavvDXbvQtX65Br70qjUyk
 XCfVSgjCyPhYHQWz8x1zA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:56 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> Thanks for the answer, although you forgot to comment on the question
> about possibly extending the new interface to work with file ranges in
> the future. For example, I have a 2 TiB file, and I am only interested
> in dropping caches for the first couple of gigabytes. Would I extend
> your interface, or would I come up with another one?

Ah, didn't quite understand what was meant with file ranges. Again, we
had not considered this so far. I guess you could make a distinction
between directories and files here. If the path points to a file, you
can have an optional argument indicating the range of bytes you would
like to drop. Something like

echo "my-file 0-1000,8000-1000" > /proc/sys/vm/sdrop_cache

If this is desirable, we can add it to the patch.
