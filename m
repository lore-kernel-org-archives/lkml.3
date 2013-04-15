Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934538Ab3DOSVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 14:21:35 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:46425 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933959Ab3DOSVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 14:21:34 -0400
MIME-Version: 1.0
In-Reply-To: <1365912098.2783.42.camel@deadeye.wl.decadent.org.uk>
References: <87r4ifxzwu.fsf@mn.cs.uvic.ca>
	<1365912098.2783.42.camel@deadeye.wl.decadent.org.uk>
Date: Mon, 15 Apr 2013 11:21:32 -0700
X-Google-Sender-Auth: G0pxMpibkDFVSQ65F0oy_1Ho2jc
Message-ID: <CAEBXXD8CZumwvOH7gLU+HQNAngHbD7eLFB48qUF_8BeYhk7fNQ@mail.gmail.com>
Subject: Re: helping with tracking commits across repos
From: dmg <dmg@uvic.ca>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On 4/13/13, Ben Hutchings <ben@decadent.org.uk> wrote:
> I notice that where a commit is cherry-picked cleanly on a stable
> branch, like 6b90466cfec2a2fe027187d675d8d14217c12d82, your script finds
> the corresponding commit on the stable branch.  This is useful.
>
> But where some backporting changes are needed, such as for
> f01fc1a82c2ee68726b400fadb156bd623b5f2f1, which became
> 8ebfe28181b02766ac41d9d841801c146e6161c1 on the 3.2.y branch, the
> corresponding commit isn't found.
>
> It should be possible to find such backported commits based on a simple
> regex search over the commit message:

I took a more aggressive approach. I decided to look for 40 length
character hashes in the
comment and patch of the commit.

if the hash is in the database of commits I maintain, then I display
it. if not, it is ignored.
You can revisit the output of that commit:

http://o.cs.uvic.ca:20810/perl/cid2.pl?cid=8ebfe28181b02766ac41d9d841801c146e6161c1

This means I am able to show when a commit is referenced by another one, and
the commits that a commit references.

hopefully this solves the use-case you described.

The commit logs are being scanned as I write this. It should be done
in a couple of hours.

--dmg

---
Daniel M. German
http://turingmachine.org
