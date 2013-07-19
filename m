Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867Ab3GSQ3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:29:31 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:47399 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab3GSQ32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:29:28 -0400
Date: Fri, 19 Jul 2013 16:29:24 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Andy Lutomirski <luto@amacapital.net>
CC: <linux-kernel@vger.kernel.org>, <gcc@gcc.gnu.org>
Subject: Re: [RFC / musing] Scoped exception handling in Linux userspace?
In-Reply-To: <CALCETrVioVM=pdCU3WhU6qDtGQyqML=btBRZ5+aV6bASj9GkOQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1307191603480.9428@digraph.polyomino.org.uk>
References: <CALCETrVioVM=pdCU3WhU6qDtGQyqML=btBRZ5+aV6bASj9GkOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 19 Jul 2013 16:29:27.0611 (UTC) FILETIME=[233AC8B0:01CE849D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jul 2013, Andy Lutomirski wrote:

> 2. It's localized.  So you can mmap something, read from it *and
> handle SIGBUS*, and unmap.

There is of course no guarantee that possibly faulting memory accesses are 
preserved (GCC should never introduce such an access where it wouldn't 
occur in the abstract machine, but may well *remove* accesses that aren't 
required).  Hopefully you don't want to rely on a guarantee that faults 
will happen....

> It's worth noting that SIGBUS isn't the only interesting signal here.
> SIGFPE could work, too.  I'm not sure whether SIGPIPE would make

The SIGFPE case could potentially be relevant for C bindings to IEEE 
754-2008 (clause 8) alternate exception handling, where the expectation is 
that various forms of exception handling attribute can be associated with 
a block.  Though what such bindings will end up looking like, and to what 
extent the various cases involved will correspond to things that could be 
implemented using SIGFPE, remains to be seen - checking floating-point 
exception flags after each operation could turn out to be a better 
implementation approach in some cases.  The C floating-point group hasn't 
got as far as designing such bindings yet (currently working on parts 1-3 
of draft TS 18661, and optional attributes are to go in part 5).

(Note: although I'm interested in these floating-point issues and am 
reviewing all the parts of the draft C bindings as they become available, 
I don't have current plans for implementing them - or the remaining bits 
of C99/C11 Annex F and Annex G not yet implemented in GCC.  There's 
certainly a lot of work to be done there in both GCC and glibc, with the 
exception handling attributes from part 5, and rounding mode attributes 
from part 1, probably among the larger pieces.)

-- 
Joseph S. Myers
joseph@codesourcery.com
