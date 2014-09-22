Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaIVOZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:25:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbaIVOZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:25:06 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Milosz Tanski <milosz@adfin.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v2 0/5] Non-blockling buffered fs read (page cache only)
References: <cover.1410810247.git.milosz@adfin.com>
	<cover.1410983998.git.milosz@adfin.com>
	<20140919104204.3b0bb762@lwn.net>
	<CANP1eJEhHyA93kDUCz_=0vDjdPXz7g0x1SmW+q060fntQAbrYA@mail.gmail.com>
	<20140922101221.4bf46809@lwn.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 22 Sep 2014 10:24:16 -0400
In-Reply-To: <20140922101221.4bf46809@lwn.net> (Jonathan Corbet's message of
	"Mon, 22 Sep 2014 10:12:21 -0400")
Message-ID: <x49h9zzspgv.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet <corbet@lwn.net> writes:

> On Fri, 19 Sep 2014 13:33:14 -0400
> Milosz Tanski <milosz@adfin.com> wrote:
>
>> >  - Non-blocking I/O has long been supported with a well-understood set
>> >    of operations - O_NONBLOCK and fcntl().  Why do we need a different
>> >    mechanism here - one that's only understood in the context of
>> >    buffered file I/O?  I assume you didn't want to implement support
>> >    for poll() and all that, but is that a good enough reason to add a
>> >    new Linux-specific non-blocking I/O technique?  
>> 
>> I realized that I didn't answer this question well in my other long
>> email. O_NONBLOCK doesn't work on files under any commonly used OS,
>> and people have gotten use to this behavior so I doubt we could change
>> that without breaking a lot of folks applications.
>
> So I'm not contesting this, but I am genuinely curious: do you think
> there are applications out there requesting non-blocking behavior on
> regular files that will then break if they actually get non-blocking
> behavior?  I don't suppose you have an example?

Hi, Jon,

Back when I tried to introduct O_NONBLOCK for regular files, the squid
proxy actually broke.  Software that dealt with burning optical media
also broke.  See my mail message here for more details:
  https://lkml.org/lkml/2014/9/15/942

Cheers,
Jeff
