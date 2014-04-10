Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbaDJSFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:05:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57127 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaDJSFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:05:34 -0400
MIME-Version: 1.0
In-Reply-To: <5346DC74.8080701@lwfinger.net>
References: <1397152016-31005-1-git-send-email-geert@linux-m68k.org>
	<5346DC74.8080701@lwfinger.net>
Date: Thu, 10 Apr 2014 20:05:32 +0200
X-Google-Sender-Auth: TSk4i0kod77w_fLnSGRtNlj4Uns
Message-ID: <CAMuHMdUvf_m=pO0-qxE+UpzBBBpjtW-w-gdSRFJt0iHPPKhNOQ@mail.gmail.com>
Subject: Re: [PATCH] staging: r8723au: Add missing initialization of
 change_inx in sort algorithm
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,

On Thu, Apr 10, 2014 at 8:01 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 04/10/2014 12:46 PM, Geert Uytterhoeven wrote:
>>
>> drivers/staging/rtl8723au/core/rtw_wlan_util.c: In function
>> ‘WMMOnAssocRsp23a’:
>> drivers/staging/rtl8723au/core/rtw_wlan_util.c:684: warning: ‘change_inx’
>> may be used uninitialized in this function
>>
>> Depending on the uninitialized data on the stack, the array may not be
>> sorted correctly.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> Geert,
>
> Thanks for this. I wonder why my gcc on x86_64 did not flag this problem.

Because it's too new?

Several warnings were disabled in more recent versions of gcc (still
using 4.1.2 for m68k here ;-) due to too many false positives.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
