Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaIVJGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:06:23 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:56731 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbaIVJGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:06:22 -0400
Message-ID: <1411376779.11208.51.camel@x220>
Subject: Re: [PATCH v3] checkkconfigsymbols.sh: reimplementation in python
From: Paul Bolle <pebolle@tiscali.nl>
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stefan.hengelein@fau.de
Date: Mon, 22 Sep 2014 11:06:19 +0200
In-Reply-To: <1411375517.6908.10.camel@nebuchadnezzar>
References: <1411222524-7850-1-git-send-email-valentinrothberg@gmail.com>
	 <1411329197-15102-1-git-send-email-valentinrothberg@gmail.com>
	 <1411334939.6049.30.camel@x41> <1411371813.3460.34.camel@nebuchadnezzar>
	 <1411374249.11208.15.camel@x220> <1411375517.6908.10.camel@nebuchadnezzar>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Sep 2014 09:06:20.0101 (UTC) FILETIME=[79773750:01CFD644]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 10:45 +0200, Valentin Rothberg wrote:
> On lun., 2014-09-22 at 10:24 +0200, Paul Bolle wrote: 
> > On Mon, 2014-09-22 at 09:43 +0200, Valentin Rothberg wrote:
> > > On dim., 2014-09-21 at 23:28 +0200, Paul Bolle wrote:
> > > 2) ./lib/Makefile: TEST_MODULE (defined in lib/Kconfig.debug)
> > 
> > TEST_MODULE is an awkward name for a Kconfig symbol. My local script has
> > it special cased.
> 
> I plan to rename this feature in a future patch, since imho it violates
> the _MODULE suffix for kernel modules.

Probably a good idea. Could you please CC me if you actually do that?

> > > > > +REGEX_FILE_SOURCE = re.compile(r"\.[cSh]$")
> > 
> > New observation: this causes the script to skip text files, shell
> > scripts, etc, doesn't it? 
> 
> Yes. Do you prefer to cover such files?

It seems useful. By now I must have pointed out stale, misspelled, or
simply odd references to Kconfig macros in Documentation and other
non-code files dozens of times. Documentation seems often overlooked
when Kconfig symbols change.

> I just grepped CONFIG_ in
> Documentation and think that covering such could improve the quality
> there too. I will put this into the next version of the patch.

You'll have to think about what to do with defconfig files. (I ignore
them in my local script, but you may want to report oddities in those
too. They are almost all outdated in one way or another.)

Hope this helps,


Paul Bolle

