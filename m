Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab3KRBIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 20:08:45 -0500
Received: from blu0-omc4-s10.blu0.hotmail.com ([65.55.111.149]:21357 "EHLO
	blu0-omc4-s10.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751599Ab3KRBIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 20:08:38 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Nov 2013 20:08:38 EST
X-TMN: [SiSCa89F49ww+YtcecAZCTWAPf6ulMmj]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP844E685A4399DA3621BB1097E40@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: Helge Deller <deller@gmx.de>
In-Reply-To: <20131117234707.GA25545@p100.box>
Subject: Re: [PATCH] aio: fix D-cache aliasing issues
References: <20131115220529.GA3160@ls3530.box> <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com> <20131116200717.GA18939@schnuecks.de> <20131116200959.GA14098@kvack.org> <528933BC.50806@gmx.de> <1384724973.2050.14.camel@dabdike.int.hansenpartnership.com> <20131117234707.GA25545@p100.box>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Sun, 17 Nov 2013 20:03:13 -0500
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-parisc@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        Simon Baatz <gmbnomis@gmail.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 18 Nov 2013 01:03:30.0817 (UTC) FILETIME=[FF324710:01CEE3F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-Nov-13, at 6:47 PM, Helge Deller wrote:

> I only changed kunmap_parisc() to always call
> flush_kernel_dcache_page_addr(addr) - independend if we are on a  
> PA8800/8900
> CPU or not - which is what you proposed in your original mail.

In which case the flushes in clear_user_page() and copy_user_page()  
aren't needed.

Dave
--
John David Anglin	dave.anglin@bell.net



