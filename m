Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaFPPsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:48:08 -0400
Received: from mout.gmx.net ([212.227.15.19]:59529 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaFPPsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:48:06 -0400
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
To: pageexec@freemail.hu
Cc: Borislav Petkov <bp@alien8.de>, Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <mcharleb@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 3d3d6b847420 ("kbuild: LLVMLinux: Adapt warnings for compilation with clang")
Date: Mon, 16 Jun 2014 17:48:01 +0200
Message-ID: <2065274.H8oo5iWEkB@aragorn.auenland.lan>
User-Agent: KMail/4.13.2 (Linux/3.11.10-7-desktop; KDE/4.13.2; x86_64; ; )
In-Reply-To: <539F0D55.31207.1DF87EFF@pageexec.freemail.hu>
References: <20140616130751.GD8170@pd.tnic> <539F0D55.31207.1DF87EFF@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V03:K0:3YcqKPNRtMht5YcOQBk26PS7HmKXrbYemS1VgtqjjVUwCKCunOm
 YOvwo76GfP+NUVKOvnEjug3axVqCF45SEDa3tEAnRCHQc9sV2ApXkTfq83d6pDl3MrffKiz
 qjB9rHnbzf8VHp+tf4im89qMdk5vc/iwKDzpy1ZBe/rxsJOmpedARU8VjjtPc7OzAREFQRA
 pL+/dHikx0TWGJ/gBVGNw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, let's wrap this case with 

ifeq ($(COMPILER),clang)
...
endif

And we'll update the stale entries.

Patch to follow after some testing.

-- 

Dipl.-Ing.
Jan-Simon Möller

jansimon.moeller@gmx.de
Am Montag, 16. Juni 2014, 17:29:25 schrieb PaX Team:
> On 16 Jun 2014 at 15:07, Borislav Petkov wrote:
> > Please fix this to have effect only for clang but not for the rest of
> > the universe.
> 
> i'd suggest reverting it instead, there're probably some stale entries
> in there already (e.g., -fcatch-undefined-behavior).

