Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934998AbaEaAoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:44:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49580 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934624AbaEaAoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:44:10 -0400
Message-ID: <5389252A.5050503@zytor.com>
Date: Fri, 30 May 2014 17:41:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>, Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-12-git-send-email-arnd@arndb.de> <20140531003712.GH14410@dastard>
In-Reply-To: <20140531003712.GH14410@dastard>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 05:37 PM, Dave Chinner wrote:
> 
> IOWs, the filesystem has to be able to reject any attempt to set a
> timestamp that is can't represent on disk otherwise Bad Stuff will
> happen,

Actually it is questionable if it is worse to reject a timestamp or just
let it wrap.  Rejecting a valid timestamp is a bit like "You don't
exist, go away."

> and filesystems have to be able to specify in their on
> disk format what timestamp encoding is being used. The solution will
> be different for every filesystem that needs to support time beyond
> 2038.

Actually the cutoff can be really different for each filesystem, not
necessarily 2038.  However, I maintain the above still holds.

Consider a filesystem that kept timestamps in YYMMDDHHMMSS format.  What
would you have expected such a filesystem to do on Jan 1, 2000?

	-hpa


