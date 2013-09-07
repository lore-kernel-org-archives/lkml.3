Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab3IGSx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 14:53:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43628 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3IGSxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 14:53:54 -0400
Date: Sat, 7 Sep 2013 19:53:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v3 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130907185351.GF13318@ZenIV.linux.org.uk>
References: <1378483738-10129-2-git-send-email-Waiman.Long@hp.com>
 <CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com>
 <20130906210546.GW13318@ZenIV.linux.org.uk>
 <CA+55aFzf-reQNSQt_fhHfUe_tB19n2qEa=Rd=wFEBJEVALmezA@mail.gmail.com>
 <20130907000044.GX13318@ZenIV.linux.org.uk>
 <CA+55aFwy_x65HaLOgKuK7AyQayraU4M6q78L_hnAvLg1NSgTpw@mail.gmail.com>
 <CA+55aFzwederWB135Ch+PjijjrN-kz9UKw+obC4+M_+xq648PA@mail.gmail.com>
 <20130907030110.GY13318@ZenIV.linux.org.uk>
 <CA+55aFyJ8CvfYzh8LFRY_6tx+GgzVfps1hSwJeSUz=G=FrsgkQ@mail.gmail.com>
 <20130907180724.GE13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130907180724.GE13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 07, 2013 at 07:07:24PM +0100, Al Viro wrote:

> with these loops turning into
> 	seq = read_seqlock(&rename_lock);
again:
> 	...
> 	if (!seqretry_and_lock(&rename_lock, &seq))
> 		goto again;
> 	...
> 	seqretry_done(&rename_lock);

Forgot the label, sorry.

And I agree that d_lookup() ought to stay as is - this is just about
the ones that try readlock once and then fall back to writer.
