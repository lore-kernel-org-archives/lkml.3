Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaAWCQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:16:00 -0500
Received: from cloud.peff.net ([50.56.180.127]:37288 "HELO peff.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753330AbaAWCP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:15:56 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jan 2014 21:15:56 EST
Date: Wed, 22 Jan 2014 21:09:13 -0500
From: Jeff King <peff@peff.net>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Junio C Hamano <gitster@pobox.com>,
        Vicent =?utf-8?B?TWFydMOt?= <tanoku@gmail.com>,
        Stefan =?utf-8?B?TsOkd2U=?= <stefan.naewe@atlas-elektronik.com>,
        Javier Domingo Cansino <javierdo1@gmail.com>,
        "git@vger.kernel.org" <git@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v1.9-rc0
Message-ID: <20140123020913.GF17254@sigill.intra.peff.net>
References: <xmqq61pjzljn.fsf@gitster.dls.corp.google.com>
 <xmqqha8xt22p.fsf@gitster.dls.corp.google.com>
 <CALZVapmqcFjjKeURHdP4chkB+T2--caJZYiJBzdwq7Ou=HzO5w@mail.gmail.com>
 <52DFE882.2040605@atlas-elektronik.com>
 <xmqq7g9syp1m.fsf@gitster.dls.corp.google.com>
 <CAFFjANTNLnc4GcVeSEvuWpfYVXJchJqkHwvUVdREdXmWx6e4=Q@mail.gmail.com>
 <xmqqlhy7yjjp.fsf@gitster.dls.corp.google.com>
 <20140122203030.GB14211@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140122203030.GB14211@milliways>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 08:30:30PM +0000, Ken Moffat wrote:

>  Two questions: Does regenerating (e.g. if the tarball has dropped
> out of the cache) change its sums (md5sum or similar) ?  In (beyond)
> linuxfromscratch we use md5sums to verify that a tarball has not
> changed.

The tarballs we auto-generate from tags are cached, but they can
change if the cached version expires _and_ the archive-generation code
changes.

We use "git archive" to generate the tarballs themselves, and then gzip
the with "gzip -n". So it should be consistent from run to run. However,
very occasionally there are bugfixes in "git archive" which can affect
the output. E.g., commit 22f0dcd (archive-tar: split long paths more
carefully, 2013-01-05) changes the representation of certain long paths,
and generating a tarball with and without it will result in different
checksums (for some repos).

So if you are planning on baking md5sums into a package-build system, it
is much better to point at "official" releases which are rolled once by
the project maintainer, rather than the automatic tag page.

Junio, since you prepare such tarballs[1] anyway for kernel.org, it
might be worth uploading them to the "Releases" page of git/git.  I
imagine there is a programmatic way to do so via GitHub's API, but I
don't know offhand. I can look into it if you are interested.

-Peff
