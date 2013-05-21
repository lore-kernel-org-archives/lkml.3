Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3EUPcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 11:32:55 -0400
Received: from sisa.samsung.com ([63.166.156.250]:40983 "EHLO
	mx2.sisa.samsung.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab3EUPcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 11:32:53 -0400
X-ASG-Debug-ID: 1369150372-051129284731090001-xx1T2L
X-Barracuda-Envelope-From: shuah.kh@samsung.com
X-Barracuda-Apparent-Source-IP: 105.144.21.115
X-ASG-Whitelist: Client
From: Shuah Khan <shuah.kh@samsung.com>
To: Gustavo Padovan <gustavo@padovan.org>
CC: "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH rebased] Bluetooth: Add missing reset_resume dev_pm_ops
Thread-Topic: [PATCH rebased] Bluetooth: Add missing reset_resume dev_pm_ops
X-ASG-Orig-Subj: Re: [PATCH rebased] Bluetooth: Add missing reset_resume dev_pm_ops
Thread-Index: AQHOVb7v3Podb/0mVEeMC1jREEoUOZkPcEUAgADKfoA=
Date: Tue, 21 May 2013 15:32:51 +0000
Message-ID: <1369150371.18338.4.camel@lorien>
References: <1367250333.4938.20.camel@lorien> <20130520230832.GF17712@joana>
	 <1369092891.8079.5.camel@lorien> <1369098178.11557.3.camel@lorien>
	 <20130521032806.GA12086@joana>
In-Reply-To: <20130521032806.GA12086@joana>
Reply-To: Shuah Khan <shuah.kh@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.144.34.6]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE90513A3D1E4041B5EC7E9EB3035330@sisa.samsung.com>
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[105.144.21.115]
X-Barracuda-Start-Time: 1369150372
X-Barracuda-URL: http://192.168.0.102:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4LFX1W1021047

On Tue, 2013-05-21 at 00:28 -0300, Gustavo Padovan wrote:
> Hi Shuan,
> 
> * Shuah Khan <shuah.kh@samsung.com> [2013-05-21 01:02:58 +0000]:
> 
> > Add missing reset_resume dev_pm_ops. Missing reset_resume results in the
> > following message after power management device test. This change sets
> > reset_resume to btusb_resume().
> > 
> > [ 2506.936134] btusb 1-1.5:1.0: no reset_resume for driver btusb?
> > [ 2506.936137] btusb 1-1.5:1.1: no reset_resume for driver btusb?
> > 
> > Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> > ---
> >  drivers/bluetooth/btusb.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> > index 7a7e5f8..1eb90c0 100644
> > --- a/drivers/bluetooth/btusb.c
> > +++ b/drivers/bluetooth/btusb.c
> > @@ -1616,6 +1616,7 @@ static struct usb_driver btusb_driver = {
> >  #ifdef CONFIG_PM
> >  	.suspend	= btusb_suspend,
> >  	.resume		= btusb_resume,
> > +	.reset_resume	= btusb_resume,
> >  #endif
> >  	.id_table	= btusb_table,
> >  	.supports_autosuspend = 1,
> 
> Patch still doesn't apply, are you sending it with git-send-email?
> 
> Applying: Bluetooth: Add missing reset_resume dev_pm_ops
> /home/padovan/p/linux-trees/bluetooth-next/.git/rebase-apply/patch:13: trailing whitespace.
>         .reset_resume   = btusb_resume,
> error: patch failed: drivers/bluetooth/btusb.c:1616
> error: drivers/bluetooth/btusb.c: patch does not apply
> Patch failed at 0001 Bluetooth: Add missing reset_resume dev_pm_ops
> 
> 	Gustavo

I saved the patch from the email I sent and applied to your latest git
and it applies. I am not sure what happened. In any case, I just resent
it using git-send-email. Hope that works.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group 
Samsung Research America (Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
