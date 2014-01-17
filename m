Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaAQQX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:23:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56776 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaAQQXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:23:53 -0500
Message-ID: <52D958FC.9020700@zytor.com>
Date: Fri, 17 Jan 2014 08:23:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Kim Naru <kim.naru@amd.com>, Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
References: <20140114114133.GA31473@khazad-dum.debian.net> <20140114115547.GA29887@pd.tnic> <52D55468.6000000@zytor.com> <20140114153534.GE29865@pd.tnic> <20140114162722.GF29865@pd.tnic> <52D59ACC.3090100@amd.com> <20140114203848.GP29865@pd.tnic> <52D81DB5.7000608@amd.com> <20140117002123.GA9165@khazad-dum.debian.net> <20140117101842.GB8715@pd.tnic>
In-Reply-To: <20140117101842.GB8715@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 02:18 AM, Borislav Petkov wrote:
> 
> We also cannot carry *every* erratum workaround in the kernel just
> because people don't update firmware. Firmware is becoming ubiquitous,
> sadly, and because of that, admins should provision for firmware
> upgrades too.
> 
> Besides, *even* if we put *all* errata fixes in the kernel, you'd need
> to update it anyway and reboot. In this case, you can just as well
> update your firmware instead, which involves that same reboot.
> 

Actually I by and large disagree with that.  There is a limit, of
course, but when it comes to flipping an MSR in init code, the bar is
pretty darn low.  We have quirks for all kind of hardware, and this is
just another example.

What *is* important, though, is that the workaround is well commented so
that when someone comes and wonders "WTF is this, and what constraints
does it have on it" they can get back to the primary sources (errata
documents, mailing list discussions, CVEs, etc.) without undue effort.

The effort of a kernel update is much lower, especially since the kernel
is generally automatically updated.  It would be awesome if that was
done for firmware, but in the absence of central distribution, arbitrary
EOL sunsets, and a standard OS-driven firmware installer, it just isn't
going to happen widely.  Yes, that is a problem.

	-hpa

