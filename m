Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbbAFBri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 20:47:38 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:34973 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbbAFBrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 20:47:36 -0500
Date: Tue, 6 Jan 2015 03:47:18 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andy Lutomirski <luto@amacapital.net>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Mark Seaborn <mseaborn@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20150106014718.GA23775@node.dhcp.inet.fi>
References: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
 <20141224220818.GA17655@amd>
 <20150105192329.5f32c155@lxorguk.ukuu.org.uk>
 <CALCETrXby82sgbGTcSZFj54t=resYcwtPbcFRNh6Ksbr+Ow8HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXby82sgbGTcSZFj54t=resYcwtPbcFRNh6Ksbr+Ow8HQ@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 11:50:04AM -0800, Andy Lutomirski wrote:
> On Mon, Jan 5, 2015 at 11:23 AM, One Thousand Gnomes
> <gnomes@lxorguk.ukuu.org.uk> wrote:
> >> In the meantime, I created test that actually uses physical memory,
> >> 8MB apart, as described in some footnote. It is attached. It should
> >> work, but it needs boot with specific config options and specific
> >> kernel parameters.
> >
> > Why not just use hugepages. You know the alignment guarantees for 1GB
> > pages and that means you don't even need to be root
> >
> > In fact - should we be disabling 1GB huge page support by default at this
> > point, at least on non ECC boxes ?
> 
> Can you actually damage anyone else's data using a 1 GB hugepage?

hugetlbfs is a filesystem: the answer is yes. Although I don't see the
issue as a big attach vector.

-- 
 Kirill A. Shutemov
