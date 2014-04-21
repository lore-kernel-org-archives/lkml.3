Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaDUSUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:20:17 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35104 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbaDUSUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:20:10 -0400
Message-ID: <53556157.7000001@gmail.com>
Date: Mon, 21 Apr 2014 20:20:07 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: mtk.manpages@gmail.com, Rich Felker <dalias@libc.org>,
        Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com> <20140421140246.GB26358@brightrain.aerifal.cx> <535529FA.8070709@gmail.com> <20140421160927.GA19653@infradead.org>
In-Reply-To: <20140421160927.GA19653@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

On 04/21/2014 06:09 PM, Christoph Hellwig wrote:
> On Mon, Apr 21, 2014 at 04:23:54PM +0200, Michael Kerrisk (man-pages) wrote:
>>
>> There's at least two problems to solve here:
>>
>> 1) "File private locks" is _meaningless_ as a term. Elsewhere
>>    (http://thread.gmane.org/gmane.network.samba.internals/76414/focus=1685376),
> 
> It's indeed not a very good choice, but the new name is even worse.
> Just call them non-broken locks? :)  Or not give them a name an just
> append a 2 to the fcntls? :)

As Jeff points out, they must have a name, or we can't have sensible
discussions about them ;-).

>> 2) The new API constants (F_SETLKP, F_SETLKPW, F_GETLKP) have names
>>    that are visually very close to the traditional POSIX lock names 
>>    (F_SETLK, F_SETLKW, F_GETLK). That's an accident waiting to happen
>>    when someone mistypes in code and/or misses such a misttyping
>>    when reading code. That really must be fixed.
> 
> I don't think so.  They also should have a name very similar because
> they have the same semantics with a major bug fixed.  In fact I can't
> think of anyone who would actually want the old behavior.

They should have a name that is similar, but not so similar that 
one is easily confused for the other. Some people will inevitably
want the other behavior. Other people will be working on alternatively
legacy and new applications. We should choose some constant names
that minimize the chance of silly mistakes. Names that differ by 
just a single letter (in one case, inside the name) are a poor 
choice from that perspective.

But, solving the naming of the constants is somewhat orthogonal
to solving the name of the entity. At the least let's have something
more visually distinctive, even if we stay with the current 
terminology. (See my other mail, just sent.)

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
