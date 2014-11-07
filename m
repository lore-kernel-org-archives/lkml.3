Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaKGXNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:13:45 -0500
Received: from toast.topped-with-meat.com ([204.197.218.159]:57463 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaKGXNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:13:44 -0500
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2014 18:13:44 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Kees Cook <keescook@chromium.org>
X-Fcc: ~/Mail/lkml
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
In-Reply-To: Kees Cook's message of  Friday, 7 November 2014 08:44:18 -0800 <CAGXu5jLBWiVieCkMFTboi5tEYw40O=-3_nH4jnMgKGQCrE6f1g@mail.gmail.com>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org>
	<353850534.aGkkrtTogX@wuerfel>
	<20141107131129.GF18916@arm.com>
	<6654405.Rf26mgoaDJ@wuerfel>
	<CAGXu5jLBWiVieCkMFTboi5tEYw40O=-3_nH4jnMgKGQCrE6f1g@mail.gmail.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20141107230503.846942C3B00@topped-with-meat.com>
Date: Fri,  7 Nov 2014 15:05:03 -0800 (PST)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.1 cv=SvUDtp+0 c=1 sm=1 tr=0
		a=WkljmVdYkabdwxfqvArNOQ==:117 a=14OXPxybAAAA:8 a=kj9zAlcOel0A:10
		a=hOe2yjtxAAAA:8 a=mX8G4SXRF6rO9a8tLyoA:9 a=CjuIK1q_8ugA:10
		a=oB8tDOL9FTQA:10 a=nUgdnsUnoyYA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not that I'm actually involved any more, but I'd endorse the user_regset
approach and not the new request.  On many (most?) machines, it's already
part of the main integer regset (orig_rax et al) and adding another
mechanism is redundant.  Using user_regset also means there won't be a word
of hidden state that is not visible in core dumps.
