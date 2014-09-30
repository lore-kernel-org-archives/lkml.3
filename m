Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaI3TdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:33:13 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:31034 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaI3TdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:33:11 -0400
From: "Zuckerman, Boris" <borisz@hp.com>
To: Matthew Wilcox <willy@linux.intel.com>
CC: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v11 00/21] Add support for NV-DIMMs to ext4
Thread-Topic: [PATCH v11 00/21] Add support for NV-DIMMs to ext4
Thread-Index: AQHP2QCmreuMoL5IZEq3psYm2+FK5ZwZdKuhgABUowCAAAGMD4AAFL6AgAAL4QCAACrTAIAAAZuw
Date: Tue, 30 Sep 2014 19:31:55 +0000
Message-ID: <4C30833E5CDF444D84D942543DF65BDA6E047CAE@G4W3303.americas.hpqcorp.net>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <15705.1412070301@turing-police.cc.vt.edu> <20140930144854.GA5098@wil.cx>
 <123795.1412088827@turing-police.cc.vt.edu> <20140930160841.GB5098@wil.cx>
 <4C30833E5CDF444D84D942543DF65BDA6E047B9B@G4W3303.americas.hpqcorp.net>
 <20140930192428.GF5098@wil.cx>
In-Reply-To: <20140930192428.GF5098@wil.cx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.16]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to refocus this thread from a particular issue to more generic needs...

Regards, Boris

> -----Original Message-----
> From: Matthew Wilcox [mailto:willy@linux.intel.com]
> Sent: Tuesday, September 30, 2014 3:24 PM
> To: Zuckerman, Boris
> Cc: Matthew Wilcox; Valdis.Kletnieks@vt.edu; Matthew Wilcox; linux-
> fsdevel@vger.kernel.org; linux-mm@kvack.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v11 00/21] Add support for NV-DIMMs to ext4
> 
> On Tue, Sep 30, 2014 at 05:10:26PM +0000, Zuckerman, Boris wrote:
> > >
> > > The more I think about this, the more I think this is a bad idea.
> > > When you have a file open with O_DIRECT, your I/O has to be done in
> > > 512-byte multiples, and it has to be aligned to 512-byte boundaries
> > > in memory.  If an unsuspecting application has O_DIRECT forced on
> > > it, it isn't going to know to do that, and so all its I/Os will fail.
> > > It'll also be horribly inefficient if a program has the file mmaped.
> > >
> > > What problem are you really trying to solve?  Some big files hogging the page
> cache?
> > > --
> >
> > Page cache? As another copy in RAM?
> > NV_DIMMs may be viewed as a caching device. This caching can be implemented on
> the level of NV block/offset or may have some hints from FS and applications.
> Temporary files is one example. They may not need to hit NV domain ever. Some
> transactional journals or DB files is another example. They may stay in RAM until power
> off.
> 
> Boris, you're confused.  Valdis is trying to solve an unrelated problem (and hopes my
> DAX patches will do it for him).  I'm explaining to him why what he wants to do is a bad
> idea.  This tangent is unrelated to NV-DIMMs.

