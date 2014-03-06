Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaCFINw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:13:52 -0500
Received: from nm29-vm8.bullet.mail.gq1.yahoo.com ([98.136.216.183]:23157 "EHLO
	nm29-vm8.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395AbaCFINu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:13:50 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 303581.24287.bm@omp1026.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=qh3BV8CZu/IiRh78z2lxutROS8f2gPFcUXJq4Zl5wKzLE1iDliEpI03DB39h89WDMTbTNcsdEWd4Gjb68UW3ZLBJNEVCNewx/HJ1ZhDw5d3vMyYIowLCQg45iVQHEJZ5CX6IidDzfAQV8bmZRLBB9tiFDXvNsm3zKS9NESRnBcA=;
X-YMail-OSG: nwAxgx4VM1lZIjTtBCUGVhlP_21m7EgoCuSfl3JxtTXe4Hx
 .iOlfjPKIhZhMCMJ28_BZhHEAmCkpU5GGEBy_c.xFqEOTxn.u7OpM6ib7Qmk
 kBf7yGveFEPnviUh5Wj_czdZCwuEdaf67AnuLpkdGpdbV2Lksgg20WQVeEoi
 MImjn1O2gi7GqDV121q6in5jjc2UAXreUTFZmysw5o8JzaTLWecELBuwHFgW
 u1PMj08jrZhL5JqoOre29vS.XCaiTd_l934zaoUn0c5ejgV_axig72wEhoH8
 fL9bbLPfYPzTLjWv8vj7aeZaLiVWs2gx6HxS.j0kx0pZDaxRUIQCH.AhumQ2
 x2OCtZhTTc9c27aNI_UvHYtXvBZItMFECB7Xj8rAvSYJWAcWP2QgeKR6S1fL
 akvh4hurOGmY_L_XCkhVJBGOl9OZ.Br9CTGuhweAIdXR5WH_Dm7yyOwIHWqR
 H7VheB1OehEfvA_67Zm6A28CLKiO8kJ64aKaTS6jOEJEnqW_ZHMctSKXz6yE
 Xm6njx_FXuNTdMKcw_dViK8UtJBY-
X-Rocket-MIMEInfo: 002.001,Pk9uIFdlZG5lc2RheSwgTWFyY2ggNSwgMjAxNCA2OjEwIEFNLCBJYW4gQWJib3R0IDxhYmJvdHRpQG1ldi5jby51az4gd3JvdGU6Cgo.Pk9uIDIwMTQtMDMtMDQgMDg6NDMsIENoYXNlIFNvdXRod29vZCB3cm90ZToKPj5UaGlzIHBhdGNoIGNoYW5nZXMgYSBoYW5kZnVsIG9mIHdoaWxlIGxvb3BzIHRvIHRpbWVvdXRzIHRvIHByZXZlbnQKPj5pbmZpbml0ZSBsb29waW5nIG9uIGhhcmR3YXJlIGZhaWx1cmUuwqAgQSBjb3VwbGUgc3VjaCBsb29wcyBhcmUgaW4gYQo.PmZ1bmN0aW9uIChzNjI2X2RlYmlfdHJhbnMBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com> <1393922628-27903-1-git-send-email-chase.southwood@yahoo.com> <531713F6.8030000@mev.co.uk>
Message-ID: <1394093630.59639.YahooMailNeo@web164001.mail.gq1.yahoo.com>
Date: Thu, 6 Mar 2014 00:13:50 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH v2 1/2] Staging: comedi: convert while loops to timeouts in s626.c
To: Ian Abbott <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <531713F6.8030000@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Wednesday, March 5, 2014 6:10 AM, Ian Abbott <abbotti@mev.co.uk> wrote:

>>On 2014-03-04 08:43, Chase Southwood wrote:
>>This patch changes a handful of while loops to timeouts to prevent
>>infinite looping on hardware failure.  A couple such loops are in a
>>function (s626_debi_transfer()) which is called from critical sections,
>>so comedi_timeout() is unusable for them, and an iterative timeout is
>>used instead.  For the while loops in a context where comedi_timeout() is
>>allowed, a new callback function, s626_send_dac_eoc(), has been defined
>>to evaluate the conditions that the while loops are testing.  The new
>>callback employs a switch statement based on the register offset values
>>that the status is to be checked from, as this information is enough to
>>recreate the entire readl() call, and is passed in the 'context'
>>parameter.  A couple of additional macros have been defined where this
>>method is not completely sufficient.  The proper comedi_timeout() calls
>>are then used.
>>
>>Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>>---
>>Ian, my idea for the callback function here is a bit iffy, I'd love to
>>hear your feedback.  I've created the ret variable because patch 2/2
>>propogates all errors upwards.
>>
>>2: Now using comedi_timeout() where allowable.

[snip]

>Rather than switching on a value that is either a register offset or 
>some special value, it might be better to use an enum to define the 
>context values you are switching on, e.g.:
>
>enum {
>    s626_send_dac_wait_not_mc1_a2out,
>    s626_send_dac_wait_ssr_af2_out,
>    s626_send_dac_wait_fb_buffer2_msb_00,
>    s626_send_dac_wait_fb_buffer2_msb_ff
>};
>
>Alternatively, different callback functions could be used for each case.

Ian,
Ah yes...this is much smarter than what I was trying before.  I've made
up a patch using this enum, and tomorrow I will get PATCH 2/2 rebased
and get a v2 of this patchset sent out.

Thanks,
Chase

>One slight oddity about the original code that waits for the MSB of FB 
>BUFFER2 to go from 0x00 to 0xFF is that it actually waits for it to 
>become non-zero.  I'm presuming the intermediate values between 0x00 and 
>0xFF are never seen.  (There is a non-Comedi, GPL'ed, Linux driver 
>available from Sensoray that makes the same assumption, but I think the 
>Comedi driver was derived from it.)
>

[snip]
>-- 
>-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
>-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
>-- 
