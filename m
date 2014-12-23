Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbaLWPiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:38:08 -0500
Received: from foo.gazonk.org ([212.247.24.42]:39903 "HELO gazonk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756284AbaLWPiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:38:05 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Dec 2014 10:38:04 EST
Date: Tue, 23 Dec 2014 16:31:21 +0100 (CET)
From: =?UTF-8?Q?Jonas_Bofj=C3=A4ll?= <j-lnxk@gazonk.org>
X-X-Sender: jonas@gazonk.org
To: linux-kernel@vger.kernel.org
Subject: Stuck in iowait regression in 3.18.1
Message-ID: <alpine.LNX.2.11.1412231609190.19634@gazonk.org>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After an uptime of a couple of days, I see some very strange i/o problems 
on Linux 3.18.1. The problem does not exist on 3.17.7 with identical 
configuration.

I originally had these problems running under VMware, using pvscsi, but I 
have since started seeing the same problems under KVM.

The process most likely to trip these problems are xz. The process gets 
stuck in iowait (D in ps) after having read or written a few hundred kB, 
almost every time it is run. The same thing has happened to a few other 
processes too (including sort and uniq), but the overwhelming majority 
work just fine.

The process _does_ get cputime eventually. A kill signal is honored in 
the time span of about an hour. Mostly. (Also, when working on reproducing 
the problem I once lost visibility of other terminal's processes under 
/proc. Could be related?)

I would like to bisect the 3.18 changes to see which one introduced this, 
but reproducing this takes several days. Any input or ideas how to hunt 
this down further?
