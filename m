Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaBQS7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:59:44 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:35232 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaBQS7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:59:41 -0500
Date: Mon, 17 Feb 2014 18:59:31 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Torvald Riegel <triegel@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
In-Reply-To: <1392487627.18779.6535.camel@triegel.csb>
Message-ID: <Pine.LNX.4.64.1402171856400.29680@digraph.polyomino.org.uk>
References: <1392183564.18779.2187.camel@triegel.csb> 
 <20140212180739.GB4250@linux.vnet.ibm.com> 
 <CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com> 
 <20140213002355.GI4250@linux.vnet.ibm.com>  <1392321837.18779.3249.camel@triegel.csb>
  <20140214020144.GO4250@linux.vnet.ibm.com>  <1392352981.18779.3800.camel@triegel.csb>
  <20140214172920.GQ4250@linux.vnet.ibm.com> 
 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com> 
 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com> 
 <20140215020815.GS4250@linux.vnet.ibm.com> 
 <CA+55aFyQTE-CzOoNn=KfDgt9bTLrUxBCXzhQ2T9kNoTy+bRQrQ@mail.gmail.com>
 <1392487627.18779.6535.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 17 Feb 2014 18:59:34.0936 (UTC) FILETIME=[66004180:01CF2C12]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Feb 2014, Torvald Riegel wrote:

> glibc is a counterexample that comes to mind, although it's a smaller
> code base.  (It's currently not using C11 atomics, but transitioning
> there makes sense, and some thing I want to get to eventually.)

glibc is using C11 atomics (GCC builtins rather than _Atomic / 
<stdatomic.h>, but using __atomic_* with explicitly specified memory model 
rather than the older __sync_*) on AArch64, plus in certain cases on ARM 
and MIPS.

-- 
Joseph S. Myers
joseph@codesourcery.com
