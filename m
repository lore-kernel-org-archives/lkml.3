Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbbASUTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:19:34 -0500
Received: from mail.sig21.net ([80.244.240.74]:40321 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbbASUTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:19:32 -0500
Date: Mon, 19 Jan 2015 21:19:06 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk,
        teg@jklm.no, jkosina@suse.cz, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Message-ID: <20150119201906.GA337@sig21.net>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <20150119180642.GA27957@sig21.net>
 <20150119183806.GA8479@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119183806.GA8479@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 02:38:06AM +0800, Greg Kroah-Hartman wrote:
> Yes, I do agree, there are lots of existing ipc solutions today that
> kdbus is not designed for, nor would it be good to use it for.  The
> majority of them being IPC that crosses the network layer, as there are
> lots of good solutions today for that problem.  That being said, I do
> know one research group that has kdbus working cross-network, just "to
> try it out", but I don't know what ever came of it.
...
> Everyone uses D-Bus today for everything on their system, so by
> replacing the underlying library with kdbus, they will continue to use
> it for everything without having to change any application or library
> code at all.

These two statements somehow contradict. From my admittedly very
limited experience, I never used D-Bus because it did not
fit my usage scenarios: I never needed a bus, only point-to-point
links like pipes or sockets.

Let me rephrase my previous, lengthy mail: Will kdbus only
support the same IPC model as D-Bus (just with higher
performance and some bells and whistles), or will it
be useful for other scenarios?  Like, can two programs
use it to communicate directly without the need of
any daemon?  (And if so, would there be any advantage
compared to traditional UNIX IPC methods?)

You were comparing kdbus and Binder.  Why?
So far my impression is that D-Bus and Binder are
completely seperate things, not just because of
the thread vs. event-loop programming model but
also because Binder is not a bus (i.e. no multicast messaging).

> Hope this helps,

Well, it made your intentions a bit clearer, but it does
not help to sell kdbus to me, sorry ;-/


Thanks,
Johannes
