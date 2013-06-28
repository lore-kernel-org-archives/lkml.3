Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3F1BOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 21:14:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3F1BOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 21:14:16 -0400
Date: Thu, 27 Jun 2013 18:13:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Minchan Kim <minchan@kernel.org>, Luiz Capitulino <lcapitulino@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mhocko@suse.cz,
        kmpark@infradead.org, hyunhee.kim@samsung.com
Subject: Re: [PATCH v2] vmpressure: implement strict mode
Message-Id: <20130627181353.3d552e64.akpm@linux-foundation.org>
In-Reply-To: <20130628005852.GA8093@teo>
References: <20130626231712.4a7392a7@redhat.com>
	<20130627150231.2bc00e3efcd426c4beef894c@linux-foundation.org>
	<20130628000201.GB15637@bbox>
	<20130627173433.d0fc6ecd.akpm@linux-foundation.org>
	<20130628005852.GA8093@teo>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013 17:58:53 -0700 Anton Vorontsov <anton@enomsg.org> wrote:

> On Thu, Jun 27, 2013 at 05:34:33PM -0700, Andrew Morton wrote:
> > > If so, userland daemon would receive lots of events which are no interest.
> > 
> > "lots"?  If vmpressure is generating events at such a high frequency that
> > this matters then it's already busted?
> 
> Current frequency is 1/(2MB). Suppose we ended up scanning the whole
> memory on a 2GB host, this will give us 1024 hits. Doesn't feel too much*
> to me... But for what it worth, I am against adding read() to the
> interface -- just because we can avoid the unnecessary switch into the
> kernel.

What was it they said about premature optimization?

I think I'd rather do nothing than add a mode hack (already!).

The information Luiz wants is already available with the existing
interface, so why not just use it until there is a real demonstrated
problem?

But all this does point at the fact that the chosen interface was not a
good one.  And it's happening so soon :( A far better interface would
be to do away with this level filtering stuff in the kernel altogether.
Register for events and you get all the events, simple.  Or require that
userspace register a separate time for each level, or whatever.

Something clean and simple which leaves the policy in userspace,
please.  Not this.

(Why didn't vmpressure use netlink, btw?  Then we'd have decent payload
delivery)
