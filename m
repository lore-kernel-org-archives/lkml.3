Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3IFOwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:52:36 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34127 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3IFOwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:52:35 -0400
MIME-Version: 1.0
In-Reply-To: <5229E9D2.9060000@lwfinger.net>
References: <1378471536-7169-1-git-send-email-geert@linux-m68k.org>
	<5229E9D2.9060000@lwfinger.net>
Date: Fri, 6 Sep 2013 16:52:34 +0200
X-Google-Sender-Auth: _Y8lqegEYvqBJmOLYn4Cn4QWQOA
Message-ID: <CAMuHMdXdXRtpYoZBG3poJAvMO+tWVg3J0Z6v2MEv0DgPw==RiA@mail.gmail.com>
Subject: Re: [PATCH] staging: r8188eu: Fix uninitialized variable change_inx
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 4:42 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 09/06/2013 07:45 AM, Geert Uytterhoeven wrote:
>> drivers/staging/rtl8188eu/core/rtw_wlan_util.c: In function
>> ‘WMMOnAssocRsp’:
>> drivers/staging/rtl8188eu/core/rtw_wlan_util.c:634: warning: ‘change_inx’
>> may be used uninitialized in this function
>>
>> And the compiler is right: change_inx should be initialized to false.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>   drivers/staging/rtl8188eu/core/rtw_wlan_util.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
>> b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
>> index 013ea48..8018edd 100644
>> --- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
>> +++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
>> @@ -631,7 +631,7 @@ void WMMOnAssocRsp(struct adapter *padapter)
>>         inx[0] = 0; inx[1] = 1; inx[2] = 2; inx[3] = 3;
>>
>>         if (pregpriv->wifi_spec == 1) {
>> -               u32     j, tmp, change_inx;
>> +               u32     j, tmp, change_inx = false;
>>
>>                 /* entry indx: 0->vo, 1->vi, 2->be, 3->bk. */
>>                 for (i = 0; i < 4; i++) {
>>
>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> This warning has not shown up on my x86_64 system with gcc 4.7.2. What
> architecture and gcc version were you using?

Good old gcc version 4.1.2 20061115 (prerelease) (Ubuntu 4.1.1-21) for m68k.

Recent versions of gcc no longer give warnings for uninitialized variables,
probably because it used to flood you with too many false positives.
This may please the -Werror camp, but once in a while the warnings do disclose
real bugs, so I tend to look at all regressions I encounter there.

I've just checked with m68k-linux-gcc 4.6.3 from crosstool on kernel.org, and
it doesn't give this warning (hmm, it does give other warnings, so I should have
a closer look...).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
