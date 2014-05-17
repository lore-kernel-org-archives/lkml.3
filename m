Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030412AbaEQR6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:58:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030236AbaEQR6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:58:40 -0400
Date: Sat, 17 May 2014 19:58:30 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Manuel =?utf-8?Q?Sch=C3=B6lling?= <manuel.schoelling@gmx.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Cleanup string initializations (char[] instead of
 char *)
Message-ID: <20140517175829.GD1939@mguzik.redhat.com>
References: <1400338818-2853-1-git-send-email-manuel.schoelling@gmx.de>
 <20140517154427.GB1939@mguzik.redhat.com>
 <20140517172109.GH18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140517172109.GH18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 06:21:09PM +0100, Al Viro wrote:
> On Sat, May 17, 2014 at 05:44:28PM +0200, Mateusz Guzik wrote:
> > This particular function would be better of with removing this variable
> > and replacing all pairs like:
> > sprintf(dp, ...);
> > dp += strlen(...)
> > 
> > with:
> > dp += sprintf(dp, ...);
> 
> Sigh...  Premature optimisation and all such... (..)

Well, I was interested in getting rid of this error-prone style, which
results in stuff like:
	sprintf(dp, "\nmask ");
	dp += 6;

... and cleaning up the rest for consistency, will note next time.

I'm new to linux and didn't know about seq_ thingy, will grep some more
next time.

-- 
Mateusz Guzik
