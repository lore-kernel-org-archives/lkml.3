Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbaCZByQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 21:54:16 -0400
Received: from nm18-vm5.bullet.mail.gq1.yahoo.com ([98.136.217.220]:44383 "EHLO
	nm18-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbaCZByP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 21:54:15 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 494258.6787.bm@omp1052.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=owNwlx0TGu4qLp/2HvmQ2JKsVz3CFvlTCMmG9XAdM6lH7waj4/MXzgdRJsVlfFslOlaL2++neCEMf2wD/PBRRgju9yIcOUln+z/pem6qKG0RiEZjUlBvQGsJK0SB3igy+sQt9DNVx0johIW2olKElhzlTahLnZshcfvvKj85Lxk=;
X-YMail-OSG: NQ3zH3oVM1lkKU.E3F9Lq97Sgc8hXY4e33fOk1fM2XG34yX
 MvrQflufrqKuQmtvcgSU988BnmGX04Dpl6fCCkS0uYJo77D8Ls9W9gy_i9lT
 xL.MFotdAqHiE6gmWuKwovfp9Ogf30eJyzNfGm7ebXdKyE16dA5PVY7ZEWO5
 G7epCI0rRgcAZJKdjzeoQKcrN6tLKK5soCU4139B5dpx059jB292mv5FqV7s
 PVjRmzDD671BFA01dAMuqNEqar3vMOU64RO1JRMIvD8uSChP8d3Stt3eC.U_
 1PXb8Gaag2t9k8FzIp.JyEfDZRHIefd.KBzYPxle09OKb2LJX8SZ6XQxtTfG
 ._URkYoohpVHTaEj0ljEF0nw0HOJAeobJm5hSeu3KTyTam8fE1Q1hHuu7sev
 JOK1yUIfOHx5HxkUu028qcN2Drt5KRGVExAOtX_yZKdAx8NYZogS_YSoB0Wk
 NddYjz_.Z2wOfQMekuAhSggbmC3yUhEbPCdH3qR7iNXKF4RnwW41Bs2WKyA-
 -
X-Rocket-MIMEInfo: 002.001,SWFuLAoKPk9uIFR1ZXNkYXksIE1hcmNoIDI1LCAyMDE0IDc6MTMgQU0sIElhbiBBYmJvdHQgPGFiYm90dGlAbWV2LmNvLnVrPiB3cm90ZToKPj5PbiAyMDE0LTAzLTI1IDA1OjA5LCBDaGFzZSBTb3V0aHdvb2Qgd3JvdGU6Cj4.VGhlcmUgd2VyZSBqdXN0IGEgaGFuZGZ1bCBvZiBtb3JlIHdoaWxlIGxvb3BzIGluIHRoaXMgZmlsZSB0aGF0IG5lZWQgdGltZW91dHMsCj4.YW5kIHRoaXMgcGF0Y2ggdGFrZXMgY2FyZSBvZiB0aGVtLCB1c2luZyBjb21lZGlfdGltZW91dCgpLsKgIEEgY291cGxlIG9mIG5ldwo.PmMBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.181.645
References: <1395724172-30183-1-git-send-email-chase.southwood@yahoo.com> <5331728F.1090301@mev.co.uk>
Message-ID: <1395798854.66905.YahooMailNeo@web164002.mail.gq1.yahoo.com>
Date: Tue, 25 Mar 2014 18:54:14 -0700 (PDT)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH] staging: comedi: s626: use comedi_timeout() on remaining loops
To: Ian Abbott <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <5331728F.1090301@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian,

>On Tuesday, March 25, 2014 7:13 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
>>On 2014-03-25 05:09, Chase Southwood wrote:
>>There were just a handful of more while loops in this file that need timeouts,
>>and this patch takes care of them, using comedi_timeout().  A couple of new
>>callbacks are introduced, but there was one case where the appropriate callback
>>function was already defined; in this case I have just used that.
>>
>>Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>
>I think it can be simplified a bit as described below.


[snip]

Thank you for all of this great feedback, I'll get this fixed up as quick as I can.

Thanks,
Chase
