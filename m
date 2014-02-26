Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbaBZG4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 01:56:08 -0500
Received: from nm30-vm6.bullet.mail.gq1.yahoo.com ([98.136.216.197]:41276 "EHLO
	nm30-vm6.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbaBZG4G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 01:56:06 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 421312.1694.bm@omp1088.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=az9Jy+x23Rq9pttySQJQJt05LLucvEXXLnyj++vOv3tbZXiuPzq+ZsucnEP62ByBuCcQhZi4IbavtshSSZA7RjyldezKPsY647d4EN1kTvtg3A32MEbdVKAZYI+0FrzRX8nR3LUviJv599m4J63TlSFM0ooNgY4dcQ2VwmabajM=;
X-YMail-OSG: X6mHh6QVM1mZaubfVSKmOhqMPnR4gw9MXYqwqDSOwnxqZ3P
 _Yy8_UB9neudHAbSEYrG6rxYmCckt._RTc6LQeNpuX27DX2k3yFm9p91x_iy
 I68ydHEuPwMhSdVfFFDjZYqvhjFhu0HtirzVlOJl1vh4oJllUVzJzblQjuxb
 iK3s5U8o.wzoER5ygu.R6C.G0wBoD3XA_eOfGfPUKSAi6mC6WewNbBv9GYXh
 3qCrQ.vk8ErsrrCM_9.r2mrLivw39g.HpN22C77WzusoM.up0zqKuWh6lhZm
 GlZ6svmtDTLKvcLYn0a1MnJOX8JGTodx6UWLovDf1NKWaGfm4HvrzlMdjLaj
 pJ01rQ410WOT7XhefGtVfgLTOgFDX047CRdJvNw3kIEx4vzhnYnLn0.Ey8nC
 Yo8hUzoU9Sk66C_9CC8LS7PHpkUTYRmLauruKunGJUUqiaULcI9sD23VzFK0
 sje8gnnr7rrGC3HGtFKkqRD7c3_RlUt7Kw9MgQxhbl7CZH2_1yBzwfjO3RzU
 TziMlexFqHhV2d.CwSFmp
X-Rocket-MIMEInfo: 002.001,Pk9uIFR1ZXNkYXksIEZlYnJ1YXJ5IDI1LCAyMDE0IDM6NTYgQU0sIElhbiBBYmJvdHQgPGFiYm90dGlAbWV2LmNvLnVrPiB3cm90ZToKCj4.T24gMjAxNC0wMi0yNSAwODoxNSwgQ2hhc2UgU291dGh3b29kIHdyb3RlOgo.PiBUaGUgc3RhdGljIHZhcmlhYmxlIHVpX0NvbW1hbmQgaXMgYXMgb2YgcmlnaHQgbm93IGJlaW5nIGNsZWFyZWQgdG8gYQo.PiB2YWx1ZSBvZiB6ZXJvIGJldHdlZW4gZXZlcnl0aW1lIHRoYXQgaXQgd3JpdGVzIHRvIGEgcG9ydCBhbmQgdGhlbiB0YWtlcyBhCj4.IG5ldyB2YWx1ZSBmcm8BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1393316127-28777-1-git-send-email-chase.southwood@yahoo.com> <530C68B7.4000500@mev.co.uk>
Message-ID: <1393397765.83843.YahooMailNeo@web164001.mail.gq1.yahoo.com>
Date: Tue, 25 Feb 2014 22:56:05 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH] Staging: comedi: addi-data: clean-up variable use in hwdrv_apci035.c
To: Ian Abbott <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <530C68B7.4000500@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Tuesday, February 25, 2014 3:56 AM, Ian Abbott <abbotti@mev.co.uk> wrote:

>>On 2014-02-25 08:15, Chase Southwood wrote:
>> The static variable ui_Command is as of right now being cleared to a
>> value of zero between everytime that it writes to a port and then takes a
>> new value from a port.  Seems like this zeroing is unnecessary, so we can
>> just remove these lines.
>
>The description is slightly wrong as the variable isn't static storage 
>class.
>

Oh, shoot, you're exactly right.  I was looking at some other variables which
are static when I was making this up and I got storage classes all mixed up.
I'll fix up the description and send it off to Greg again as it hasn't been
applied yet.

>>
>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>> ---
>> This sort of thing seems like a copy/paste sort of error to me, but there
>> could as easily be some reason here that I'm missing that this is needed
>> here.  My first impression, however, was that this extra clearing is
>> useless.
>
>Yes, the extra clearing was useless.  There are also some useless 
>initializers for this variable and others.
>
>Fine, apart from the description.
>
>Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
>
>-- 
>-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
>-=( Tel: +44 (0)161 477 1898  FAX: +44 (0)161 718 3587        )=-
