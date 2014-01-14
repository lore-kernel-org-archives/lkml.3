Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaANOVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:21:31 -0500
Received: from mail-gg0-f176.google.com ([209.85.161.176]:42001 "EHLO
	mail-gg0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaANOV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:21:29 -0500
Date: Tue, 14 Jan 2014 11:21:23 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf probe: Build error with missing libraries
Message-ID: <20140114142123.GC29798@ghostprotocols.net>
References: <20140113180400.GD5318@ghostprotocols.net>
 <20140113181458.GE5318@ghostprotocols.net>
 <52D495D1.5080505@hitachi.com>
 <20140114130907.GA29798@ghostprotocols.net>
 <20140114131540.GB5520@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114131540.GB5520@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 14, 2014 at 02:15:40PM +0100, Jiri Olsa escreveu:
> On Tue, Jan 14, 2014 at 10:09:07AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Jan 14, 2014 at 10:41:37AM +0900, Masami Hiramatsu escreveu:
> > > (2014/01/14 3:14), Arnaldo Carvalho de Melo wrote:
> > > > Jiri, this is something else for the give-me-more-ponies list for
> > > > tests/make: build it on freshly provisioned systems with multiple mixes
> > > > of devel packages installed ;-)

> > > I think we can change makefile to get some combinations of config options
> > > when building perf tools.

> > This is what:
> > 
> >  make -C tools/perf -f tests/make

> > does, and we use it already, many config combos are tested, but that
> > kinda expects that all optional devel libs be installed.

> > What I'm talking about is to, in addition, install the devel packages
> > iteratively, testing those config options combos with and without
> > installed devel packages combos.

> yep, sounds good.. maybe another script setting the environment
> (randomly, with some logic never to repeat any config?) and running
> tests/make suite

What I'm usually doing, from time to time, when people report problems
building on some specific distro, is to install a VM with the default
set of packages, then try to build perf and go on installing the strict
requirements, then add the suggested libraries for features marked as
OFF by the automatic feature detection mechanism.

Something that kinda replicated that, perhaps using 'mock'
(https://fedoraproject.org/wiki/Using_Mock_to_test_package_builds) or
something similar, could help testing that.

- Arnaldo
