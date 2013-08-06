Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab3HFOJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:09:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33935 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752013Ab3HFOJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:09:27 -0400
Message-ID: <1375798166.2424.12.camel@joe-AO722>
Subject: Re: [PATCH 1/1] checkpatch: fix some whitespace issues caused by
 --fix
From: Joe Perches <joe@perches.com>
To: Phil Carmody <phil.carmody@partner.samsung.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Date: Tue, 06 Aug 2013 07:09:26 -0700
In-Reply-To: <000901ce927b$c5b74c80$5125e580$%carmody@partner.samsung.com>
References: <1375700932-2851-1-git-send-email-phil.carmody@partner.samsung.com>
	 <1375750807.1968.20.camel@joe-AO722>
	 <000901ce927b$c5b74c80$5125e580$%carmody@partner.samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 11:05 +0300, Phil Carmody wrote:
> > On Mon, 2013-08-05 at 14:08 +0300, Phil Carmody wrote:
> > > Lines with incorrect spacing around an operator, such as:
> > >   bystander, correct,incorrect
> > > would get "fixed" to
> > >   bystander,correct, incorrect
> > > as the correct argument as well as the incorrectly-spaced operator
> > > were both being trimmed. The correct argument only needs to be right
> > > trimmed.
> > 
> > Thanks for the patch, but I think it needs a different fix.
> 
> I think it's the right approach, but you're right,
> fix all the problems. However, in part that's because many 
> copies of the string, or bits of it, are created, and when 
> one copy is modified, the others don't replicate that change.
> 
> > Even after your patch the --fix option still makes a mess of several
> > code spacing issues.
> 
> Indeed. Just seen - func(foo,&bar); becoming func(foo,  &bar);, 
> as --fix wants to put a space both after the ',' and before the '&'.

Hi Phil.

Basically, checkpatch needs to left trim the
"$fix_elements[$n + 2])" if it exists.

> > I'll work on it and propose something soonish.
> 
> It's very much a WIP - I'll send my bride-of-checkpatch to you 
> as soon as I've written some blurb. It might be that the 
> complexities inside checkpatch can't be overcome, and it's
> easier to address the changes entirely in a separate script?

Maybe, but humans are lazy.

Maybe the "bride-of" approach will work better,
It's hard to know right now.  No worries, you try
yours too and one or the other or both might be
the "right" approach.

btw:

The biggest complexity might be handling patches
that need lines added or removed by rewriting
the patch contexts.

Maybe creating an interdiff would be better than
rewriting the patch or file.

I was too lazy to do that to checkpatch for a
first pass.


