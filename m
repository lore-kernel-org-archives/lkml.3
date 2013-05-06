Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3EFOBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:01:12 -0400
Received: from mx1.sisa.samsung.com ([63.166.156.249]:51278 "EHLO
	mx1.sisa.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3EFOBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:01:10 -0400
X-ASG-Debug-ID: 1367848864-05c03262a706fb0001-xx1T2L
X-Barracuda-Envelope-From: shuah.kh@samsung.com
X-Barracuda-Apparent-Source-IP: 105.144.21.115
X-ASG-Whitelist: Client
From: Shuah Khan <shuah.kh@samsung.com>
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH] PM: Fix dev_pm_put_subsys_data() to not call kfree()
 while holding device power lock
Thread-Topic: [PATCH] PM: Fix dev_pm_put_subsys_data() to not call kfree()
 while holding device power lock
X-ASG-Orig-Subj: Re: [PATCH] PM: Fix dev_pm_put_subsys_data() to not call kfree()
 while holding device power lock
Thread-Index: AQHOSD9WkkQkCwYLLkewoPShwxGqcpj1cPsAgAMYZICAAACUgIAAHysA
Date: Mon, 6 May 2013 14:01:03 +0000
Message-ID: <1367848858.2953.1.camel@lorien>
References: <1367614010.8452.2.camel@lorien>
	 <20130504125116.GA13770@amd.pavel.ucw.cz>
	 <1882177.s6zpHZ6crc@vostro.rjw.lan>
	 <20130506120925.GA25542@amd.pavel.ucw.cz>
In-Reply-To: <20130506120925.GA25542@amd.pavel.ucw.cz>
Reply-To: Shuah Khan <shuah.kh@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.144.34.5]
Content-Type: text/plain; charset="utf-8"
Content-ID: <92158966F363BD40ACCD5DAAB0E255EF@sisa.samsung.com>
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[105.144.21.115]
X-Barracuda-Start-Time: 1367848864
X-Barracuda-URL: http://192.168.0.101:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r46E1LOU023917

On Mon, 2013-05-06 at 14:09 +0200, Pavel Machek wrote:
> Hi!
> 
> > > Wow, that function is fragile. It returns 0/1/-EINVAL, while being
> > > documented for 0/1...
> > 
> > Oh, it generally should return 1 for !psd.
> > 
> > > Patch does not look obviously wrong, but maybe 
> > > 
> > > @@ -73,13 +73,17 @@ int dev_pm_put_subsys_data(struct device *dev)
> > >  
> > >  	if (--psd->refcount == 0) {
> > >  		dev->power.subsys_data = NULL;
> > > +		spin_unlock_irq(&dev->power.lock);
> > > -		kfree(psd);
> > > - 		ret = 1;
> > > +		return 1;
> > >  	}
> > > 
> > > Would be cleaner.
> > 
> > What about this:
> 
> Looks good to me.
> 
> Reviewed-by: Pavel Machek <pavel@ucw.cz>

Rafael/Pavel,

I redid the patch based on Pavel's comments and just about to send it
and then I saw your exchange. This version looks good to me. Do you want
me to test the patch and resend?

thanks,
-- Shuah
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
