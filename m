Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3B1Hcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 02:32:41 -0500
Received: from vostochny.stro.at ([78.47.22.85]:59619 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab3B1Hch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 02:32:37 -0500
Date: Thu, 28 Feb 2013 07:32:35 +0000
From: maximilian attems <max@stro.at>
To: Michal Marek <mmarek@suse.cz>
Cc: Sedat Dilek <sedat.dilek@googlemail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH 1/3] kbuild, deb-pkg: Try to determine distribution
Message-ID: <20130228073235.GP10026@vostochny.stro.at>
References: <1335219389-10887-1-git-send-email-sedat.dilek@gmail.com>
 <512E1061.3030007@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512E1061.3030007@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 02:55:45PM +0100, Michal Marek wrote:
> Sorry I missed this series. Max, can you have a look? I don't know the
> policies for debian package changelogs. The full series is at
> http://lkml.indiana.edu/hypermail/linux/kernel/1204.2/index.html#04252,
> but the remaining two patches are obvious.

the two remaining ones are trivial, should have pushed them a long time
ago and will do so this weekend in a combined version going up to 2013
(sitting in my queue to send).
 
> On 24.4.2012 00:16, Sedat Dilek wrote:
> > Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> > ---
> >  scripts/package/builddeb |   15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> > index eee5f8e..f5b56ac 100644
> > --- a/scripts/package/builddeb
> > +++ b/scripts/package/builddeb
> > @@ -172,9 +172,22 @@ else
> >  fi
> >  maintainer="$name <$email>"
> >  
> > +# Try to determine distribution
> > +if [ -e $(which lsb_release) ]; then
> > +       codename=$(lsb_release --codename --short)
> > +       if [ "$codename" != "" ]; then
> > +		distribution=$codename
> > +       else
> > +		distribution="UNRELEASED"
> > +		echo "WARNING: The distribution could NOT be determined!"
> > +       fi
> > +else
> > +       echo "HINT: Install lsb_release binary, this helps to identify your distribution!"
> > +fi
> > +
> >  # Generate a simple changelog template
> >  cat <<EOF > debian/changelog
> > -linux-upstream ($packageversion) unstable; urgency=low
> > +linux-upstream ($packageversion) $distribution; urgency=low
> >  
> >    * Custom built Linux kernel.

this is pretty useless. 
Nack, in adding a this additional lsb dep.
I know it should be installed by default, but in practise it is often not.

If you'd really care about the changelog you'd generate it out of your
git repo with Debian's git dch in order to have something meaningful.


-- 
maks
