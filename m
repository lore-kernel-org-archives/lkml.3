Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaFRTxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:53:08 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:41013 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbaFRTxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:53:06 -0400
Date: Wed, 18 Jun 2014 21:52:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: relative objtree change broke tar builds?
Message-ID: <20140618195259.GA21939@ravnborg.org>
References: <20140617223854.GC6168@fieldses.org>
 <53A15684.9000002@suse.cz>
 <20140618122029.GA17790@fieldses.org>
 <53A18712.6030907@suse.cz>
 <20140618131452.GB17790@fieldses.org>
 <53A1B72E.7030907@infradead.org>
 <53A1ECD0.2030001@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A1ECD0.2030001@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 09:47:28PM +0200, Michal Marek wrote:
> Dne 18.6.2014 17:58, Randy Dunlap napsal(a):
> > On 06/18/14 06:14, J. Bruce Fields wrote:
> >> On Wed, Jun 18, 2014 at 02:33:22PM +0200, Michal Marek wrote:
> >>> Dne 18.6.2014 14:20, J. Bruce Fields napsal(a):
> >>>> On Wed, Jun 18, 2014 at 11:06:12AM +0200, Michal Marek wrote:
> >>>>> Dne 18.6.2014 00:38, J. Bruce Fields napsal(a):
> >>>>>> The changelog there says
> >>>>>>
> >>>>>> 	The main Makefile sets its working directory to the object tree
> >>>>>> 	and never changes it again. Therefore, we can use '.' instead of
> >>>>>> 	the absolute path.
> >>>>>>
> >>>>>> But the main Makefile also exports objtree, and a quick grep suggests
> >>>>>> lots of other uses outside the main Makefile.
> >>>>>
> >>>>> Do you have examples? Besides your report, I'm only aware of make
> >>>>> deb-pkg and make *docs. What else?
> >>>>
> >>>> I haven't looked.
> >>>>
> >>>> I only note that grep finds 47 files referencing that variable, and
> >>>> absent some argument that the remaining ones are correct, I'd be
> >>>> inclined to revert.
> >>>
> >>> Do these 47 files change the working directory before referencing the
> >>> variable?
> >>
> >> Sorry, I'm not volunteering to check.
> >>
> >> Note also that other variables are defined in terms of objtree, and they
> >> may be exported or passed to other scripts.
> > 
> > 
> > I'll note one side effect that I really dislike:
> > If not in silent mode, scripts/mkmakefile tells me that the it is
> > generating ./Makefile.  I want to see the real path there instead of '.'.
> 
> The idea is that one should be able to compare as much as possible
> between the build of /usr/src/linux-<version_a> built in
> /usr/src/linux-<version_a>/build and /usr/src/linux-<version_b> built in
> /usr/src/linux-<version_b>/build. One can now even compare the build log
> with -j1, although that was not the primary goal. So if the changed
> message is considered problematic, I can change it to show the full path
> again, like
> 
> diff --git a/scripts/mkmakefile b/scripts/mkmakefile
> index 84af27b..9d291f5 100644
> --- a/scripts/mkmakefile
> +++ b/scripts/mkmakefile
> @@ -18,7 +18,7 @@ then
>         exit 0
>  fi
>  if [ "${quiet}" != "silent_" ]; then
> -       echo "  GEN     $2/Makefile"
> +       echo "  GEN     $(cd $2 && /bin/pwd)/Makefile"
>  fi
> 
>  cat << EOF > $2/Makefile
> 
> Opinions?
I agree with Randy - the full path is more informative.

	Sam
