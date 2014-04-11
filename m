Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbaDKM4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:56:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbaDKM4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:56:08 -0400
Date: Fri, 11 Apr 2014 18:25:55 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Michael Fyles <mf@vorston.net>
cc: linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] initramfs: remove "compression mode" choice
In-Reply-To: <1397217807.13525.21.camel@x220>
Message-ID: <alpine.LFD.2.10.1404111807030.13489@wniryva.cad.erqung.pbz>
References: <20140411112611.GA508@dev0.mafconsulting.com> <1397217807.13525.21.camel@x220>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hello Michael,

+-- On Fri, 11 Apr 2014, Paul Bolle wrote --+
| On Fri, 2014-04-11 at 12:26 +0100, Michael Fyles wrote:
| > Commit 9ba4bcb64589 mistakenly forced the logic in usr/Makefile
| > to prioritise the selection of RD options such that selecting
| > more than one supported compression pretty much rail-roads you
| > into having your initrd compressed with gzip. This happends
| > because because suffix-y gets updated once for each supported
| > compression and, by default (on x86, at least) all compressions
| > are supported.

   IIUC, that's not because of the commit. Even earlier it was the same. 
Because that's how Makefile reads and updates the variables. Now that .gzip is 
listed last in the make file, it defaults to .gzip when all options are set. 
Otherwise it would default to .lz4  or .lzo before lz4 was introduced.

   See -> https://lkml.org/lkml/2013/12/23/170

| > If 1 is chosen, it would be advantageous to have RD as a
| > mutually-exclusive choice -- this would be the place to put all
| > the help texts that your patch removes.
| > 
| > I currently have a patch that performs 2, if you decide that
| > might be better.

   I don't get it. You mean one option for build time compression and another 
for run time compression? Shouldn't those two be exactly same?

--
  - P J P
