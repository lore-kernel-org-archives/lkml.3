Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaAWH2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:28:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaAWH2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:28:39 -0500
Date: Thu, 23 Jan 2014 07:28:33 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, gnome@rvzt.net,
        drawoc@darkrefraction.com, alan@lxorguk.ukuu.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 67651] Bisected: Lots of fragmented mmaps cause gimp to
 fail in 3.12 after exceeding vm_max_map_count
Message-ID: <20140123072833.GC4963@suse.de>
References: <20140122190816.GB4963@suse.de>
 <20140122115215.f723ddf2e2a3c3d4b6ab9bf3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140122115215.f723ddf2e2a3c3d4b6ab9bf3@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 11:52:15AM -0800, Andrew Morton wrote:
> On Wed, 22 Jan 2014 19:08:16 +0000 Mel Gorman <mgorman@suse.de> wrote:
> 
> > X-related junk is there was because I was using a headless server and
> > xinit directly to launch gimp to reproduce the bug.
> 
> I've never done this.  Can you share the magic recipe for running an X
> app in this way?
> 

The relevant part of the test script is

# Build a wrapper script to launch gimp
cat > gimp-launch.sh << EOF
/usr/bin/gimp -i -b "(mmtests-open-image \"$FILENAME\")" -b "(gimp-quit 0)" > $LOGDIR_RESULTS/gimp-out.1 2>&1
echo \$? > gimp-exit-code
EOF
chmod u+x gimp-launch.sh

$TIME_CMD xinit ./gimp-launch.sh 2> $LOGDIR_RESULTS/time.1
RETVAL=`cat gimp-exit-code`

It's clumsy because the application would start with no window manager
and looking at it again, it probably was not even necessary because of
the -i switch in gimp.

Previously when I needed to automate an X app I configured the machine to
login automatically, exported the DISPLAY variable in the test script and
used wmctrl to detect if an application had a window displayed yet.

-- 
Mel Gorman
SUSE Labs
