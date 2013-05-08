Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab3EHWtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 18:49:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45411 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab3EHWtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 18:49:17 -0400
Message-ID: <518AD65E.1080509@zytor.com>
Date: Wed, 08 May 2013 15:49:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Stefan Bader <stefan.bader@canonical.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: WT memory type on x86_64?
References: <CALCETrVBor6fKwxP=+0mtJ4SjKn2YrFczSdXhazw3m8E5Sxx6A@mail.gmail.com> <20130508143505.GA8599@phenom.dumpdata.com> <518A6BF0.2060705@canonical.com> <CALCETrXr0mGPk0XeH-pEzTEEmFm9YbGYP=BTCBLpd1zh_GQtdQ@mail.gmail.com>
In-Reply-To: <CALCETrXr0mGPk0XeH-pEzTEEmFm9YbGYP=BTCBLpd1zh_GQtdQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 09:37 AM, Andy Lutomirski wrote:
>>
>> Not sure whether this is the reason but UC and UC- (as well as WB) are kept like
>> the backward compatible setup. So for systems with and without PAT cache types
>> map to the same. Only WT gets replaced by WC. For that whenever PCD is set it
>> means some uncached type.
> 
> This also makes the pgprot_xyz macros faster -- they can do the same
> thing regardless of PAT settings.
> 

It also deals with errata in some very old CPUs... old enough that we
don't use PAT on them anyway AFAIK.

	-hpa


