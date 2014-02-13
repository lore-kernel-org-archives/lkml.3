Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaBMT7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:59:43 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44870 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbaBMT7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:59:41 -0500
Date: Thu, 13 Feb 2014 20:59:08 +0100
From: Florian Westphal <fw@strlen.de>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Patrick McHardy <kaber@trash.net>, Cong Wang <cwang@twopensource.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vitaly Lavrov <lve@guap.ru>
Subject: Re: ip_set: protocol %u message -- useful?
Message-ID: <20140213195908.GK25153@breakpoint.cc>
References: <CAKb7UvhsLi2Sv4SWA2nVTgoFV8dzrY=3R1-SUk9D-aa0VdizSA@mail.gmail.com>
 <alpine.DEB.2.10.1402131117120.16734@blackhole.kfki.hu>
 <CAHA+R7MeEEfqz-7RhCUjsoWPx_BKHVXFV3Y32xjf0B1WwjNdRQ@mail.gmail.com>
 <20140213184254.GF14175@macbook.localnet>
 <CAKb7UvjdPco0zrP9Ry4mPv40r-bnfNgKEfwcOvJb4JU-5XcTaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKb7UvjdPco0zrP9Ry4mPv40r-bnfNgKEfwcOvJb4JU-5XcTaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> > Maybe printing "using protocol version X" will make it appear less like
> > a debugging message referring to packet contents or something similar.
> 
> With pr_info it'll still appear in dmesg, and it'll still be "random
> non-sensical message appears over and over in dmesg" type of
> situation, to the vast majority of users. Do we need a print every
> time someone creates a new tcp connection too? I'm still not totally
> clear on the cause of this message getting printed, but I was seeing
> it a whole bunch in my configuration...

Yes, because it erronously got moved into the netns init function.

And thats what causes the spew.  Moving it back into module init
function should be enough.
