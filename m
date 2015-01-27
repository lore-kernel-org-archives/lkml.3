Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbbA0HXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 02:23:30 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:52855 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbA0HX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 02:23:26 -0500
Date: Tue, 27 Jan 2015 10:23:23 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Calvin Owens <calvinowens@fb.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [RFC][PATCH v2] procfs: Always expose /proc/<pid>/map_files/ and
 make it readable
Message-ID: <20150127072323.GI651@moon>
References: <20150114153323.GF2253@moon>
 <20150114204653.GA26698@mail.thefacebook.com>
 <20150114211613.GH2253@moon>
 <20150122024554.GB23762@mail.thefacebook.com>
 <20150124031544.GA1992748@mail.thefacebook.com>
 <20150126124731.GA26916@node.dhcp.inet.fi>
 <20150126210054.GG651@moon>
 <20150126154346.c63c512e5821e9e0ea31f759@linux-foundation.org>
 <20150127064647.GH651@moon>
 <20150126225023.df63f6ca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126225023.df63f6ca.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 10:50:23PM -0800, Andrew Morton wrote:
> On Tue, 27 Jan 2015 09:46:47 +0300 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > > There's one other problem here: we're assuming that the map_files
> > > implementation doesn't have bugs.  If it does have bugs then relaxing
> > > permissions like this will create new vulnerabilities.  And the
> > > map_files implementation is surprisingly complex.  Is it bug-free?
> > 
> > I didn't find any bugs in map-files (and we use it for long time already)
> > so I think it is safe.
> 
> You've been using map_files the way it was supposed to be used so no,
> any bugs won't show up.  What happens if you don your evil black hat
> and use map_files in ways that weren't anticipated?  Attack it?

Hard to say, Andrew. If I found a way to exploit this feature for
bad purpose for sure I would patch it out. At the moment I don't
see any. Touching another process memory via file descriptor
allows one to modify its contents but you have to be granted
ptrace-may-access which i consider as enough for security.
