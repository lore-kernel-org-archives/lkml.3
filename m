Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbaKUPtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:49:03 -0500
Received: from mout.web.de ([212.227.17.12]:54307 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758218AbaKUPtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:49:00 -0500
Message-ID: <546F5ED7.1000206@users.sourceforge.net>
Date: Fri, 21 Nov 2014 16:48:39 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: USB: serial: Deletion of an unnecessary check before the function
 call "release_firmware"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546F5831.5060404@users.sourceforge.net> <alpine.DEB.2.10.1411211625380.2433@hadrien>
In-Reply-To: <alpine.DEB.2.10.1411211625380.2433@hadrien>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:uQcfhuLBTM1Zf115SKsFuxP+90GeGgQRg90RdpLyimoW7NSHTw2
 sEBqrLj58Teia5OuGkMVoPDhkPElrMwDAz5w94xTeYC7uE/ymJRFFZ4Q13Ea976Z1P54d3k
 Xl7KwdO65fvoorMLFsLGlVy7ZgrqywSLEDHVjqHenj7zXHXMqWhmG9f7RBjAqMmNXWfpEt3
 M/7ERVtnXhQp41Nvm17fg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/drivers/usb/serial/mxuport.c b/drivers/usb/serial/mxuport.c
>> index ab1d690..3653ec1 100644
>> --- a/drivers/usb/serial/mxuport.c
>> +++ b/drivers/usb/serial/mxuport.c
>> @@ -1101,8 +1101,7 @@ static int mxuport_probe(struct usb_serial *serial,
>>  	 */
>>  	usb_set_serial_data(serial, (void *)id->driver_info);
>>  out:
>> -	if (fw_p)
>> -		release_firmware(fw_p);
>> +	release_firmware(fw_p);
> 
> I think that the if should stay.

I have got an other opinion.


> There were two cases on the allocation, so there should be two cases
> on the release.

I find that this implementation detail does not really matter for the
necessity of a null pointer check directly before such a function call.

Regards,
Markus
