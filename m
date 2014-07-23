Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbaGWPTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:19:42 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54149 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757732AbaGWPTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:19:40 -0400
X-Sasl-enc: kUYsT6l/RpWFHVBR1Sjf2131dm/goMFO5lzqRtU9MaWL 1406128779
Message-ID: <1406128778.26440.9.camel@localhost>
Subject: Re: Reading large amounts from /dev/urandom broken
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jul 2014 17:19:38 +0200
In-Reply-To: <20140723151459.GA6673@thunk.org>
References: <CANZNk81nyws__swPUoxz912wi5PJ2CBXbiLpJ-Jc4oLcX+J8vw@mail.gmail.com>
	 <20140723151459.GA6673@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mi, 2014-07-23 at 11:14 -0400, Theodore Ts'o wrote:
> On Wed, Jul 23, 2014 at 04:52:21PM +0300, Andrey Utkin wrote:
> > Dear developers, please check bugzilla ticket
> > https://bugzilla.kernel.org/show_bug.cgi?id=80981 (not the initial
> > issue, but starting with comment#3.
> > 
> > Reading from /dev/urandom gives EOF after 33554431 bytes.  I believe
> > it is introduced by commit 79a8468747c5f95ed3d5ce8376a3e82e0c5857fc,
> > with the chunk
> > 
> > nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
> > 
> > which is described in commit message as "additional paranoia check to
> > prevent overly large count values to be passed into urandom_read()".
> > 
> > I don't know why people pull such large amounts of data from urandom,
> > but given today there are two bugreports regarding problems doing
> > that, i consider that this is practiced.
> 
> I've inquired on the bugzilla why the reporter is abusing urandom in
> this way.  The other commenter on the bug replicated the problem, but
> that's not a "second bug report" in my book.
> 
> At the very least, this will probably cause me to insert a warning
> printk: "insane user of /dev/urandom: [current->comm] requested %d
> bytes" whenever someone tries to request more than 4k.

Ok, I would be fine with that.

The dd if=/dev/urandom of=random_file.dat seems reasonable to me to try
to not break it. But, of course, there are other possibilities.

Bye,
Hannes

