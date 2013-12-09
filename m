Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716Ab3LIWCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 17:02:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37203 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab3LIWCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 17:02:05 -0500
Message-ID: <52A63DCF.2060504@zytor.com>
Date: Mon, 09 Dec 2013 14:01:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>	<alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>	<CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>	<alpine.LNX.2.00.1312092210280.24835@pobox.suse.cz>	<CAMe9rOrDmtHXZ1cA1or_XkktSPguDnH8sNLGM_oxj7bcsek4ww@mail.gmail.com>	<52A63AD4.2030101@zytor.com>	<CAMe9rOqEO271PUUkPAQu5hnZFyTX2viUXg8R0hpwDky0B-seyg@mail.gmail.com>	<52A63BF3.1000608@zytor.com> <CAMe9rOqF5f2Wktsqf_43hwa_c20+_S+W8N5VDZ6TVqPXDh7puw@mail.gmail.com>
In-Reply-To: <CAMe9rOqF5f2Wktsqf_43hwa_c20+_S+W8N5VDZ6TVqPXDh7puw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 01:59 PM, H.J. Lu wrote:
> 
> A Linux/x86-64 user came to me at the end of 2008.  He needed
> to load an executable above 4GB.  I added -Ttext-segment option
> to linker:
> 
> https://sourceware.org/ml/binutils/2009-01/msg00173.html
> 
> so that he could load his program compiled as PIE above 4GB.
> If kernel is changed not to honor it, his program won't work any more.
> In normal case, PIE has zero vaddr and this doesn't apply.
> 

That doesn't seem to be PIE at all, and if it is PIE, then it should be
relocatable (I agree btw with randomizing upward from the selected address.)

	-hpa

