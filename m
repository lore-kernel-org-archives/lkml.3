Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046Ab3EZDn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 23:43:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002Ab3EZDn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 23:43:58 -0400
Message-ID: <1369539830.5893.23.camel@marge.simpson.net>
Subject: Re: [PATCH v2] ipc/sem.c: fix lockup, restore FIFO behavior
From: Mike Galbraith <bitbucket@online.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 26 May 2013 05:43:50 +0200
In-Reply-To: <1369538388.5893.15.camel@marge.simpson.net>
References: <1369495011-2586-1-git-send-email-manfred@colorfullife.com>
	 <51A0FB23.3050301@redhat.com>
	 <1369506721.2065.10.camel@buesod1.americas.hpqcorp.net>
	 <51A11851.2010303@colorfullife.com>
	 <1369538388.5893.15.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:mu5E6/BNaf+/3IAtkU5hdYSHaHTByDKukKB5vgjD5SI
 9JsA/laukyJwcMPJ1WDHWOH4uHEv6rDTQ0s6KV8CT1rUV+mTk0
 z9e1npAP0qr59It+3iECtQ6kQP2vFab2eaPlyH3eguypeCuprq
 3+YEwcoJ5MLiuS8WvuqCtMgebJBn0Tk8aHtBQ3+8/qT+W/17z4
 G11VpszdEbGaPUb69FDovxdJ8E1kXhyG8BoPTg3SD2Mp3614LS
 QrAhJxeWXz8WEH2SnZLV1dLrpK88HjPMnlF8lo7IivTJwVn3LL
 MI0ujMFF9/KaMGxU6NVNAEcaKzWWbNc8YTLGOyf+ReMOXj5xjo
 9itjtBIUbV50UNUkX6GRLg6E2wTnVU1oUnnB3SNn00XrGW032w
 ucomIeZCSHfRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-05-26 at 05:19 +0200, Mike Galbraith wrote: 
> On Sat, 2013-05-25 at 22:00 +0200, Manfred Spraul wrote:
> 
> > P.S.:
> > Btw, I found some code that uses a semop with 2 ops:
> > http://publib.boulder.ibm.com/infocenter/iseries/v5r3/index.jsp?topic=%2Fapis%2Fapiexusmem.htm
> 
> I recently analyzed rt traces containing 9 ops.

P.S. I dearly hope your patch flies, for otherwise I shall be sweating
frickin' bullets when the application that does that meets a new kernel.

