Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3FWUDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 16:03:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42423 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3FWUDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 16:03:04 -0400
Message-ID: <51C75465.9060007@zytor.com>
Date: Sun, 23 Jun 2013 13:02:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Brice Goglin <brice.goglin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: MTRR use in drivers
References: <51C3DDFA.7050204@zytor.com> <51C69732.1010906@gmail.com> <b8bfa877-5663-4a93-94b4-6ea313e4d563@email.android.com> <20130623192936.GA28655@khazad-dum.debian.net>
In-Reply-To: <20130623192936.GA28655@khazad-dum.debian.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 12:29 PM, Henrique de Moraes Holschuh wrote:
> On Sun, 23 Jun 2013, H. Peter Anvin wrote:
>> Why do you care about performance when PAT is disabled?
> 
> It will regress already slow boxes.  We blacklist a LOT of P4s, PMs, etc and
> nobody ever took the pain to track down which ones of those actually have
> PAT+MTRR aliasing bugs.
> 
> These boxes have boards like the Radeon X300, which needs either PAT or MTRR
> to not become unusable...
> 

We're talking hardware which is now many years old, but this is causing
very serious problems on real, modern hardware.  As far as I understand
it, too, the blacklisting was precautionary (the only bug that I
personally know about is a performance bug, where WC would be
incorrectly converted to UC.)

We need a way forward here.  If it is the only way I think we would have
to sacrifice the old machines, but perhaps something can be worked out
(e.g. if PAT is disabled, fall back to MTRRs if available for ioremap_wc()).

	-hpa

