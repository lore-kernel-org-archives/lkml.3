Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3JaKzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:55:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab3JaKze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:55:34 -0400
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
From: Mark Wielaard <mjw@redhat.com>
To: Pekka Enberg <penberg@iki.fi>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com,
        dsahern@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
In-Reply-To: <5270F2DE.6040505@iki.fi>
References: <20131023044511.1886.82571.stgit@hemant-fedora>
	 <20131023050502.1886.15779.stgit@hemant-fedora>
	 <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
	 <y0mbo2cs2oa.fsf@fche.csb> <5270D9F7.3090105@hitachi.com>
	 <5270F2DE.6040505@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Oct 2013 11:54:46 +0100
Message-ID: <1383216886.6521.5910.camel@bordewijk.wildebeest.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 13:51 +0200, Pekka Enberg wrote:
> On 10/30/13 12:05 PM, Masami Hiramatsu wrote:
> > To find all system libraries, we can use ldconfig.
> >
> > $ ldconfig --print-cache
> >
> > shows what dynamic libraries will be loaded. On my own laptop (running
> > ubuntu13.04) shows ~1000 libs.
> 
> Good point. That definitely narrows down the scanned set.

It is fast. But that would miss the various libjvm.so variants for
example. Or other programs, like libreoffice, which have SDT probes in
their internal shared libraries that aren't in the default ldconfig
paths.

Cheers,

Mark

