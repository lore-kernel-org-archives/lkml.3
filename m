Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaBMR2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:28:41 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:40249 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaBMR2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:28:37 -0500
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20106.1392309770@warthog.procyon.org.uk>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
	<19258.1392306854@warthog.procyon.org.uk>
	<20140213162534.GB4026@tucsk.piliscsaba.szeredi.hu>
	<20106.1392309770@warthog.procyon.org.uk>
Date: Thu, 13 Feb 2014 18:28:35 +0100
Message-ID: <CAJfpegtTDgLY=koYwg8m=snyD8FQ_EFyvLWErhcQ1jprAcOrrA@mail.gmail.com>
Subject: Re: [PATCH 00/13] cross rename v4
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Zach Brown <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 5:42 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> Regarding whiteouts, I raised a couple of questions that nobody answered
>> yet, so let me ask again.
>>
>> - If a filesystem containing whiteouts (fallthroughs, etc...) is mounted as
>>   not part of a union, how are these special entities represented to
>>   userspace?
>
> I would suggest that whiteouts appear as otherwise negative dentries and that
> they don't appear in getdents().

I'd argue that this is an administration nightmare.  E.g. what if the
a backup needs to be made of the rw layer?

Will rmdir work normally in a directory containing whiteouts?  Will
the VFS take care of that, just like if it was part of a union?  Or
will it fail with ENOTEMPTY despite *appearing* empty?

And zillion other problems related to the fact that things happen to a
filesystem even when they do not appear to happen ("mv foo bar; mv bar
foo" has side effects).

Thanks,
Miklos
