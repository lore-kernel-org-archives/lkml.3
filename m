Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaIEFsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 01:48:33 -0400
Received: from [83.145.59.144] ([83.145.59.144]:58585 "EHLO
	stoexhub03.domain01.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbaIEFsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 01:48:31 -0400
Date: Fri, 5 Sep 2014 07:47:49 +0200
From: Anders Darander <anders@chargestorm.se>
To: Yinghai Lu <yinghai@kernel.org>
CC: Matt Fleming <matt@console-pimps.org>,
        Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Laszlo Ersek <lersek@redhat.com>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Message-ID: <20140905054749.GA4498@ad.chargestorm.se>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
 <20140904100137.GK3001@console-pimps.org>
 <5408D299.5000300@zytor.com>
 <20140904212925.GL3001@console-pimps.org>
 <CAE9FiQUDLoARj-Z3ipPTf2sZgGn71SxrxM+FqLE1Cyb-OEoP+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQUDLoARj-Z3ipPTf2sZgGn71SxrxM+FqLE1Cyb-OEoP+A@mail.gmail.com>
X-Accept-Language: sv, en, de
X-GPG-Fingerprint: 5AF0 B2E9 78FE 9D75 D110  6F8F 3E31 84D7 920E 938C
X-GPG-Key-Id: 0x920E938C
X-GPG-Keyserver: hkp://keys.gnupg.net
Organization: ChargeStorm AB
User-Agent: Mutt/1.5.23 (2014-03-12)
X-GFI-SMTP-Submission: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yinghai@kernel.org> [140905 03:19]:


> On Thu, Sep 4, 2014 at 2:29 PM, Matt Fleming <matt@console-pimps.org> wrote:
> > On Thu, 04 Sep, at 01:59:05PM, H. Peter Anvin wrote:

> >> I am fine with this patch, but at the same time I do want to note that
> >> there is an alternative to double-buffer the patch and/or (if that
> >> applies to the buggy BIOS) round up the size of the target buffer.

> > I'm not sure that rounding up the size of the target buffer will
> > workaround this issue correctly.

> > As far as I know, the only thing that Mantas tried was rounding up the
> > size of the source file, by padding it.

> Can you try attached patch on top of linus tree?

I took the liberty to test the patch on my Dell XPS13 9333, and
unfortunately I got the old hang back. 

This was tested on the current Linus' tree.

Cheers,
Anders Darander

> -					chunksize = size;
> +					chunksize = round_up(size, EFI_PAGE_SIZE);



-- 
It usually takes more than three weeks to prepare a good impromptu speech.
		-- Mark Twain
