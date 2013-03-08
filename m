Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602Ab3CHSLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:11:21 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:30996 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933675Ab3CHSLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:11:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloFAIMpOlFbdWObgWdsb2JhbABDvGQih0iBWxYOAQEWJiiCLAEBBSdRARALGAkWDwkDAgECAUUGDQEFAgEBiBO7Ho8MB4NAA5ZTk30
X-IPAS-Result: AloFAIMpOlFbdWObgWdsb2JhbABDvGQih0iBWxYOAQEWJiiCLAEBBSdRARALGAkWDwkDAgECAUUGDQEFAgEBiBO7Ho8MB4NAA5ZTk30
X-IronPort-AV: E=Sophos;i="4.84,809,1355094000"; 
   d="scan'208";a="8779981"
Message-ID: <513A29B6.9080008@igalia.com>
Date: Fri, 08 Mar 2013 19:11:02 +0100
From: =?ISO-8859-1?Q?Samuel_Iglesias_Gons=E1lvez?= <siglesias@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jens Taprogge <jens.taprogge@taprogge.org>
Subject: Re: [PATCH 1/3] ipack: avoid double free on device->id
References: <512DCB33.6030500@igalia.com> <1362730907-10047-1-git-send-email-siglesias@igalia.com> <20130308174701.GA13276@kroah.com>
In-Reply-To: <20130308174701.GA13276@kroah.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 03/08/2013 06:47 PM, Greg Kroah-Hartman wrote:
> On Fri, Mar 08, 2013 at 09:21:45AM +0100, Samuel Iglesias
> Gonsalvez wrote:
>> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com> 
>> --- drivers/ipack/ipack.c |    1 + 1 file changed, 1 
>> insertion(+)
>> 
>> diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c index 
>> 7ec6b20..599d4ff 100644 --- a/drivers/ipack/ipack.c +++ 
>> b/drivers/ipack/ipack.c @@ -24,6 +24,7 @@ static void 
>> ipack_device_release(struct device *dev) { struct ipack_device 
>> *device = to_ipack_dev(dev); kfree(device->id); +	device->id = 
>> NULL;
> 
> How does that keep anything from being freed twice?
> 
>> device->release(device);
> 
> device should now be gone after this call, right?  What am I 
> missing?
> 

Yes, you are right. It's not possible to have it freed twice once it's
in ipack_device_release().

You can skip this patch. If you want, I can resend the others accordingly.

Sam

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCAAGBQJROim2AAoJEH/0ujLxfcNDY+sQAMfrjjs05FJ9wmQvqEFKg18I
QVddG8BbHKDzdmSTkDlagijTE/Q7eOOFV7zOKz6QWJjO14ktPjr56cFwEmIl0KPj
LcDO4+4bIsOfhO64ZJ7CHUFyMcq3olrZNBhQLJZU1anOcDKIimzomGGPXv5PPFe6
BXnRNeXEnS81r3LXQtlJM7h8th3objKWW2R5No40E9sHIKWEgYR7JmgCqhk0fQNv
RKA9FjyBFpF8RjPoi+xSdPYhFPLpOv99ZbYK1wU4goD4ADw9Npujw/66CjFtgJGx
BH3MquLaCYvCmJK6+obQJzWKl1TonQ153hh6uM1b7h+5RJ4yhUSaSPRLLIWGAxRH
3XlbtjMO6bwEDAEg2hOq9whmoVxK70YvjKOCkqo8crwqVsLccMnv4OzoE4NNrm99
8cdUScK8cTi5fg2HuIEJMVTPxpfLk46Ab3OTO9hoVURyRG84TnJ0SLK0CPzy6J1z
ORgZWh7PlEsgLeqsqjKv7q/5tcLLPEGZcV7TekWPBfNVR5aneemHrEIaSIuVYXxw
a7INgvaAWNhqGhag86KwVH0ICbz2xuJu6wtrlFhyMZWhdPN5aEcHwXusjUBhrdrm
DXoEDBFvJShBE8PxNPWYIBcrphetaSQzl0vNsO/SqacGlppsAqtvvU6hkkAuhGeO
a8dpR7nIR8tuz4NPnFHu
=NypR
-----END PGP SIGNATURE-----
