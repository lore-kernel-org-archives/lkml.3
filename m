Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaFJVwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:52:37 -0400
Received: from lekensteyn.nl ([178.21.112.251]:50241 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbaFJVwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:52:35 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] net: wireless: rtlwifi: rtl8192de: hw.c: Cleaning up conjunction always evaluates to false
Date: Tue, 10 Jun 2014 23:52:32 +0200
Message-ID: <1846364.4CH2xgjm71@al>
User-Agent: KMail/4.13.1 (Linux/3.15.0-rc8-custom-00058-gd2cfd31; KDE/4.13.1; x86_64; ; )
In-Reply-To: <CAFo99gYCYkONL9dZYeHwuJKQTCgFQTmg1aAGZdFAOT=MNARh7Q@mail.gmail.com>
References: <1402151419-18296-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <CAFo99gZuPV=v1k90iPkAGVFrzVq-z=-h8UgD5a3VCN=wMDNU3w@mail.gmail.com> <CAFo99gYCYkONL9dZYeHwuJKQTCgFQTmg1aAGZdFAOT=MNARh7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Score: -0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2014 23:31:37 Rickard Strandqvist wrote:
> I guess it's ok to do the patches?

Right, you got some feedback from me and another person. You can
send patches whenever you like.

> But then again, I will then send them one by one, with the cover
> letter? +35 email?

Have you seen my other reply? Use git-format-patch --cover-letter.
Why would you need 35 mails? A commit should logically group a
change per driver. So, one commit probably touches rtlXXXX/reg.h
and rtlXXXX/hw.c (perhaps others? grep for it!)

Be sure to manually check each change. Your last patchset included
non-sensial commit messages and subjects.

> Then the macro I should add in all the:
> 
> net/wireless/rtlwifi/rtl****se/reg.h
> 
> 
> And in the:
> drivers/staging/rtl8188eu/include/rtl8188e_spec.h
> drivers/staging/rtl8192e/rtl8192e/r8192E_hw.h
> drivers/staging/rtl8712/rtl871x_wlan_sme.h
> drivers/staging/rtl8723au/include/rtl8723a_spec.h
> drivers/staging/rtl8821ae/rtl8821ae/reg.h

The staging drivers will be taken by Greg KH, see MAINTAINERS
for the addresses for staging drivers.

> And should I put it like:
> #define MSR_MASK 0x03
> 
> Or is this more accurate:
> #define MSR_MASK   (MSR_INFRA | MSR_ADHOC)

Since the integer resulting from the mask is a decimal sequence rather
than a bitmap, it makes more sense to use 0x03 instead. Please have a
look at the drivers and be sure to understand why the changes are needed.

Peter

PS. please do not top-post. For driver discussions, you should keep
the list cc'd too. That makes it more likely for someone to respond to
such queries.

