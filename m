Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaETPYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:24:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaETPYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:24:13 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Larry.Finger" <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>
Subject: Re: randconfig build error with next-20140520, in drivers/staging/rtl8723au/core/rtw_cmd.c
References: <CA+r1ZhhhL5CB5_e_0g--biDfmqHEsC-C9RKg7uPSupYtSNLiQw@mail.gmail.com>
Date: Tue, 20 May 2014 17:23:56 +0200
In-Reply-To: <CA+r1ZhhhL5CB5_e_0g--biDfmqHEsC-C9RKg7uPSupYtSNLiQw@mail.gmail.com>
	(Jim Davis's message of "Tue, 20 May 2014 06:47:18 -0700")
Message-ID: <wrfj8upwpj77.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Davis <jim.epost@gmail.com> writes:
> Building with the attached random configuration file,
>
> drivers/staging/rtl8723au/core/rtw_cmd.c: In function ‘dynamic_chk_wk_hdl’:
> drivers/staging/rtl8723au/core/rtw_cmd.c:1036:2: error: implicit declaration of
> function ‘rtl8723a_sreset_xmit_status_check’ [-Werror=implicit-function-declarat
> ion]
>   rtl8723a_sreset_xmit_status_check(padapter);
>   ^
> drivers/staging/rtl8723au/core/rtw_cmd.c:1041:2: error: implicit declaration of
> function ‘rtl8723a_HalDmWatchDog’ [-Werror=implicit-function-declaration]
>   rtl8723a_HalDmWatchDog(padapter);
>   ^
> drivers/staging/rtl8723au/core/rtw_cmd.c: In function ‘c2h_evt_hdl’:
> drivers/staging/rtl8723au/core/rtw_cmd.c:1314:4: error: implicit
> declaration of function ‘c2h_handler_8723a’
> [-Werror=implicit-function-declaration]
>     ret = c2h_handler_8723a(adapter, c2h_evt);
>     ^
> drivers/staging/rtl8723au/core/rtw_cmd.c: In function ‘rtw_evt_work’:
> drivers/staging/rtl8723au/core/rtw_cmd.c:1348:2: error: implicit
> declaration of function ‘c2h_id_filter_ccx_8723a’
> [-Werror=implicit-function-declaration]
>   if (c2h_id_filter_ccx_8723a(ework->u.c2h_evt.id) == true) {
>   ^
>   CC      drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.o
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/staging/rtl8723au/core/rtw_cmd.o] Error 1

Jim,

Thanks for the report.

I already pushed a fix for the CONFIG_8723AU_BT_COEXIST=n problem, and
the CONFIG_8723AU_AP_MODE=n case isn't causing build problems in my tree
at this point. I believe this is due to moving a number of functions
around. There were some warnings about unused functions which I fixed up
here, but nothing breaking the build.

If you don't mind, I prefer to push it all out with my next batch of
changes rather than trying to fix up this build case.

Cheers,
Jes
