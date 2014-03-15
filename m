Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaCOHSm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 03:18:42 -0400
Received: from nm28-vm1.bullet.mail.gq1.yahoo.com ([98.136.216.160]:46952 "EHLO
	nm28-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108AbaCOHSl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 03:18:41 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 542576.58637.bm@omp1102.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=alnIbTYrOiAXYOWQ9m6os3CDpX6sSDeNCT1mXS71KERraAvjzdt7IpK7Q+QbDRmG8Sqx+ZEpoxbMV98OpaHBhBuVukbf+P790uCjOFNTJHjBvIONZPrBwAEsx/9aD9/Cc5JgW1L2auOKOUrDCSQyd8f7N6WrvAwZMA1sYy4o3pM=;
X-YMail-OSG: tneUJq0VM1mjefzCdwEBy0twudV.a0EfUGqHuftI9SBgsM2
 mdIX0XUXh1b9Cy3DYW2ls3zTRhY.YOQ6XGbGTlgV8w_zTv_BGf0Kgua7zrjn
 B6qAgi94RhFffIgA0w873mM0IzIIkuCPQaWnBrLarSrjn.l2JuD7fW2yJTQE
 yUNUoVcknGB05ke4_ssuB6.K_qKlhtoZWAKe_qiDbJppKCfCb9rYQhpNsMFm
 o.nPkJgD3a.5V64xHKFiTQnRo3TOL4yQ4h1Iqnv2WN5ffZdSMtS3EsBkBJcR
 Ygy0c2MojicyPxA94uOBJJwb7wTYWct6E7vP3pHIpYgoT7R9jdDOpOCuv74I
 KGMXjnNuWVMJRlf6t6AN3wH0av4CdBjD_IXVwa9v4NLCPHmA6S78sAcz__Ss
 fLYcNBt1diRCP.4NEW2DFLUdm6zdiV.fb_jY.YDl_eqv5WF_lMG9tzzFCcan
 bbFfsO6RPmTJWTzT_HHVzm3I0b4FnEoc8W.8lJdlpzsoIKaid.Yu31V6dtXE
 TaavvTKLafQ--
X-Rocket-MIMEInfo: 002.001,Pk9uIFNhdHVyZGF5LCBNYXJjaCAxNSwgMjAxNCAxMjoyNiBBTSwgImdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnIiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc.IHdyb3RlOgoKPj5PbiBGcmksIE1hciAxNCwgMjAxNCBhdCAwNjo0MzozN1BNIC0wNzAwLCBDaGFzZSBTb3V0aHdvb2Qgd3JvdGU6Cj4.Pk9uIFR1ZXNkYXksIE1hcmNoIDExLCAyMDE0IDk6MjYgQU0sIElhbiBBYmJvdHQgPGFiYm90dGlAbWV2LmNvLnVrPiB3cm90ZToKPj4.Pk9uIDIwMTQtMDMtMDkgMDQ6MDAsIENoYXNlIFNvdXRod29vZCABMAEBAQE-
X-Mailer: YahooMailWebService/0.8.178.641
References: <20140309030056.GA10867@kroah.com> <1394337654-27379-1-git-send-email-chase.southwood@yahoo.com> <531F1D18.4060109@mev.co.uk> <1394847817.37014.YahooMailNeo@web164005.mail.gq1.yahoo.com> <20140315052656.GA29821@kroah.com>
Message-ID: <1394867920.11004.YahooMailNeo@web164005.mail.gq1.yahoo.com>
Date: Sat, 15 Mar 2014 00:18:40 -0700 (PDT)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH v3 1/2] Staging: comedi: convert while loops to timeouts in s626.c
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20140315052656.GA29821@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Saturday, March 15, 2014 12:26 AM, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org> wrote:

>>On Fri, Mar 14, 2014 at 06:43:37PM -0700, Chase Southwood wrote:
>>>On Tuesday, March 11, 2014 9:26 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
>>>>On 2014-03-09 04:00, Chase Southwood wrote:
>>>> This patch changes a handful of while loops to timeouts to prevent
>>>> infinite looping on hardware failure. A couple such loops are in a
>>>> function (s626_debi_transfer()) which is called from critical sections,
>>>> so comedi_timeout() is unusable for them, and an iterative timeout is
>>>> used instead. For the while loops in a context where comedi_timeout() is
>>>> allowed, a new callback function, s626_send_dac_eoc(), has been defined
>>>> to evaluate the conditions that the while loops are testing.  The new
>>>> callback employs a switch statement based on a simple new enum so that
>>>> it is usable for all of the different conditions tested in while loops
>>>> in s626_send_dac().  The proper comedi_timeout() calls are then used.
>>>>
>>>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>>>> ---
>>>> Ian, here is a version of this patchset employing the enum you recommended.
>>>> The second patch has been rebased on top of this one.
>>>>
>>>> 2: Used comedi_timeout() where appropriate, introduce callback function
>>>>
>>>> 3: Updated callback to switch on new enum.>
>>>
>>>Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
>>>
>>>For future reference, for patches affecting a single comedi driver, we 
>>>usually title the patches like this:
>>>
>>>staging: comedi: name_of_driver: summary of patch
>>>
>>
>>
>>Hi Greg!
>>
>>I was just writing to inquire whether you were able to add this patch as well as
>>PATCH 2/2 Propagate timeout errors in s626.c, to your queue in their current state.
>>I had to resend this patch to you about a week ago because the subject line got
>>a little messed up, which might have lead to a bit of confusion regarding the 2
>>patch series, and I wanted to check in to see whether you need me to do anything
>>further.
>
>I've been on vacation this week and will dig through my huge patch queue
>next week.  Then I will need another vacation...
>
>Give me a chance to catch up, I'll let you know if I have problems with
>them.>
>
>thanks,
>
>greg k-h

Greg,

Oh shoot, my apologies.  I don't mean to rush you at all!  I'll chill out a bit...

Thanks,
Chase
