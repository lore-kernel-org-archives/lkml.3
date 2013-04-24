Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470Ab3DXWBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:01:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758268Ab3DXWBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:01:20 -0400
Date: Wed, 24 Apr 2013 18:01:11 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH v2] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
Message-ID: <20130424220111.GJ15272@hansolo.jdub.homelinux.org>
References: <CAGXu5jL=Lg6OeWyhKBWHowwMeOpFipMOXmBosYHY53MfVMo8fA@mail.gmail.com>
 <1256775981.281402.1364864751771.JavaMail.root@redhat.com>
 <CAGXu5jLU40Vzx+bNyPSArBt_yYNO9sPJ3yLj7z3Yq=pH22W1Gw@mail.gmail.com>
 <20130409005050.GE18176@hansolo.jdub.homelinux.org>
 <20130409154820.GE32476@hansolo.jdub.homelinux.org>
 <CAGXu5jLs1ghuCwcu7crOG1OHuiaP3hmzYY410br_puc9i82-2g@mail.gmail.com>
 <CAPXgP10Vd3Ucxn77WX7wzQoaUmy-JdOBWvYv4zpGSu9qcd=GoQ@mail.gmail.com>
 <20130424175835.GF15272@hansolo.jdub.homelinux.org>
 <CAGXu5jLaQ=Amui3i5+MyG_3HOVnK-1ZoaLqw=jFDwaQCzE+4qw@mail.gmail.com>
 <CA+55aFxVwcf82qUUferCcm-L1u1GgtJ5g21hj3Em1AETyBDTVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxVwcf82qUUferCcm-L1u1GgtJ5g21hj3Em1AETyBDTVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 02:30:53PM -0700, Linus Torvalds wrote:
> On Wed, Apr 24, 2013 at 1:35 PM, Kees Cook <keescook@chromium.org> wrote:
> >
> > That said, I much prefer doing the privilege test at read time since
> > that means passing a file descriptor to another process doesn't mean
> > the new process can just continue reading.
> 
> Bullshit.
> 
> That's exactly the wrong kind of thinking. If you had privileges to
> open something, and you pass it off, it's *your* choice.
> 
> In contrast, the "anybody can open, but some people can read/write"
> has several times resulted in real security issues. Notably the whole
> "open something, then fool a suid program to write its error message
> to it".
> 
> This whole discussion has been f*cking moronic. The "security"
> arguments have been utter shite with clearly no thinking behind it,
> the feature is total crap (people need dmesg to do basic bug
> reporting), and I'm seriously considering just getting rid of this
> idiotic dmesg_restrict thing entirely. Your comment is the very
> epitome of bad security thinking.

I was just trying to get the 3 interfaces all honoring the same thing.

Let this be a lesson to you all: I am the harbinger of security
features removal.  If you see me sending patches, run away or I might
accidentally cross the streams and make your feature undergo total
protonic reversal.

Now if only I could use this power for good, like somehow getting Linus
to remove capabilities entirely...

josh
