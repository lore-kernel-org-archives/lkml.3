Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab3CFUCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:02:36 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37734 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754749Ab3CFUCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:02:34 -0500
Message-ID: <1362600153.1759.58.camel@joe-AO722>
Subject: Re: nouveau lockdep splat
From: Joe Perches <joe@perches.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Lucas Stach <dev@lynxeye.de>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Date: Wed, 06 Mar 2013 12:02:33 -0800
In-Reply-To: <513799A5.3010609@wwwdotorg.org>
References: <20130304211608.GD22274@pd.tnic>
	 <1362501052.1933.2.camel@antimon> <20130306000429.GA30189@pd.tnic>
	 <20130306191418.GA3400@joi.lan> <513799A5.3010609@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 12:31 -0700, Stephen Warren wrote:
> On 03/06/2013 12:14 PM, Marcin Slusarz wrote:
> > On Wed, Mar 06, 2013 at 01:04:29AM +0100, Borislav Petkov wrote:
> >> On Tue, Mar 05, 2013 at 05:30:52PM +0100, Lucas Stach wrote:
> >>> Dropping Tegra ML, it's not the place where Nouveau mails should go.
> >>
> >> $ ./scripts/get_maintainer.pl -f drivers/gpu/drm/nouveau/nv50_display.c
> >> ...
> >> linux-tegra@vger.kernel.org (open list:TEGRA SUPPORT)
> >>
> >> Maybe get_maintainer.pl patterns need correction...
> > 
> > That's new feature (introduced in commit eb90d0855b75f8 "get_maintainer: allow
> > keywords to match filenames") of get_maintainer.pl which now can look at file
> > contents...
> 
> get_maintainer.pl could always look at file contents IIRC. The change
> was that I added keyword "tegra" to the Tegra section that now matches
> this file's contents.
> 
> ./scripts/get_maintainer.pl -f drivers/gpu/drm/nouveau
> 
> ... might be a better invocation, although perhaps I should add an
> explicit exclusion for "nouveau" to the Tegra section in MAINTAINERS.

Another option might be avoid overloading the "K:"
entry and use a different letter for the file name
pattern match (maybe "N") and avoid looking for
tegra in the file or patch without another specific
"K:" keyword match.

Maybe:
---
 MAINTAINERS               | 10 +++++++---
 scripts/get_maintainer.pl |  2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e95b1e9..76e0223 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -96,10 +96,14 @@ Descriptions of section entries:
 	   F:	net/
 	   X:	net/ipv6/
 	   matches all files in and below net excluding net/ipv6/
+	N: Filename wildcard pattern match, for instance:
+	   N:	(?i)[^a-z]tegra
+	   matches any filename with case insensitive "tegra" but not
+	   any other word like integrate
 	K: Keyword perl extended regex pattern to match content in a
-	   patch or file, or an affected filename.  For instance:
+	   patch or file.  For instance:
 	   K: of_get_profile
-	      matches patch or file content, or filenames, that contain
+	      matches patch or file content, that contain
 	      "of_get_profile"
 	   K: \b(printk|pr_(info|err))\b
 	      matches patch or file content, or filenames, that contain one or
@@ -7866,7 +7870,7 @@ L:	linux-tegra@vger.kernel.org
 Q:	http://patchwork.ozlabs.org/project/linux-tegra/list/
 T:	git
git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
 S:	Supported
-K:	(?i)[^a-z]tegra
+N:	(?i)[^a-z]tegra
 
 TEHUTI ETHERNET DRIVER
 M:	Andy Gospodarek <andy@greyhouse.net>
diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index ce4cc83..5e4fb14 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -611,7 +611,7 @@ sub get_maintainers {
 				    $hash{$tvi} = $value_pd;
 				}
 			    }
-			} elsif ($type eq 'K') {
+			} elsif ($type eq 'N') {
 			    if ($file =~ m/$value/x) {
 				$hash{$tvi} = 0;
 			    }



