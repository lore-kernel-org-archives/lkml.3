Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3HVKfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 06:35:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab3HVKfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 06:35:21 -0400
Date: Thu, 22 Aug 2013 12:35:16 +0200
From: Anton Arapov <anton@redhat.com>
To: kernel@gentoo.org
Cc: linux-kernel@vger.kernel.org
Subject: oops.kernel.org, reporting.  [Was: [ATTEND] oops.kernel.org prospect]
Message-ID: <20130822103516.GA2597@bandura.laptop>
References: <20130819085405.GA22328@bandura.laptop>
 <20130819145505.GB15178@kroah.com>
 <20130819151643.GC19070@bandura.laptop>
 <20130819153939.GA23875@thunk.org>
 <20130819155202.GF19070@bandura.laptop>
 <20130821223121.336c71d0@TOMWIJ-GENTOO>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821223121.336c71d0@TOMWIJ-GENTOO>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thank you for contacting me. I will cross-post this to LKML, as there
is an information that might be interested for other folks.

On Wed, Aug 21, 2013 at 10:31:21PM +0200, Tom Wijsman wrote:
> We, the Gentoo Kernel Project Team at Gentoo Linux, might be interested
> to contribute oopses to oops.kernel.org; but from a first look over what
> can be found on the ML and the internet about that site, there seems to
> be no information available about submitting to oops.kernel.org.
This kind of information will be there soon.


> So, could you please highlight the details on how submission happens?
> Does this (have to) happen automatically? Can we do manual submissions?
oops.kernel.org uses the old legacy kerneloops.org's api for data
collecting. Both, http://submit.kerneloops.org/submitoops.php (old) and
http://oops.kernel.org/submitoops.php (new, stick to this one) works today.

Reporting doesn't happen automatically. Two tools available for
sending reports: abrt/libreport (1) and former kerneloops daemon (2).
Either of these can send reports automatically or manually.


(1) https://fedorahosted.org/abrt/ - iirc, is already packaged in gentoo.
(2) There are no link to kerneloops, this is what I was able to google:
http://ftp.debian.org/debian/pool/main/k/kerneloops/kerneloops_0.12+git20090217.orig.tar.gz
Abrt has a better scanner/reporter, which produce less false-positive reports.


I don't know what way Gentoo will choose, but the original kerneloops
daemon requires some love to make it run under systemd and improve the
oops scanner (can be ported from abrt).


The source of _scanner_ abrt/dumpoops_plugin:
https://git.fedorahosted.org/cgit/abrt.git/tree/src/plugins/abrt-dump-oops.c
The source of _reporter_ abrt/libreport/kerneloops_plugin:
https://git.fedorahosted.org/cgit/libreport.git/tree/src/plugins/reporter-kerneloops.c

libreport allows to report manually using CLI:
 $ reporter-kerneloops 
 Usage: reporter-kerneloops [-v] [-c CONFFILE]... -d DIR


> I think that something that "calls home" might become a concern; maybe
> we could still provide that as opt-in, but manual submits would be neat.
Few years of experience with Abrt/Bugzilla reports, people fill the
additional information in less than 2% of all reports. And, the Abrt
team is working towards the least possible interaction with the user.
This is mostly to address privacy concerns, as well as leaving the
possibility to provide additional data.


> Thank you in advance for your explanation.
You are welcome, let me know if you'll need any help further.

Anton.
