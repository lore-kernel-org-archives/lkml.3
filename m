Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3H0GAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:00:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57848 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752505Ab3H0GAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 02:00:48 -0400
Message-ID: <1377583247.2658.13.camel@joe-AO722>
Subject: Re: [trivial PATCH] treewide: Fix printks with 0x%#
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jiri Kosina <trivial@kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniele Venzano <venza@brownhat.org>, Andi Kleen <andi@firstfloor.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel <alsa-devel@alsa-project.org>
Date: Mon, 26 Aug 2013 23:00:47 -0700
In-Reply-To: <201308270139.29838.vapier@gentoo.org>
References: <1374778405.1957.21.camel@joe-AO722>
	 <201308270139.29838.vapier@gentoo.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 01:39 -0400, Mike Frysinger wrote:
> On Thursday 25 July 2013 14:53:25 Joe Perches wrote:
> > Using 0x%# emits 0x0x.  Only one is necessary.
> 
> sounds like a job for checkpatch.pl :)

Here.  Submit it yourself...
---
 scripts/checkpatch.pl | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9ba4fc4..520f8e7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3869,6 +3869,18 @@ sub process {
 			}
 		}
 
+# check for formats with "0x%#"
+		if ($line =~ /"X*"/) {
+			my $fmt = get_quoted_string($line, $rawline);
+			if ($fmt =~ /0x%#/) {
+				if (WARN("REDUNDANT_HEX",
+					 "Redundant hex prefix 0x format\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$linenr - 1] =~ s/0x%#/%#/g;
+				}
+			}
+		}
+
 # Check for misused memsets
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&



