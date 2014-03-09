Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaCIDz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 22:55:59 -0500
Received: from nm21-vm4.bullet.mail.gq1.yahoo.com ([98.136.217.51]:20934 "EHLO
	nm21-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287AbaCIDz5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 22:55:57 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 363846.98728.bm@omp1079.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=5kzdG1Ug1w1ml8TNqBEalBNQctYYVAJV4MQOwJZR8UIJY4cu5FLu8mXA7m6t+/+c7fX4kNC7RNPtdGjfB/OcKZJPYD5tvRRo1fbDwop3jWyVSi9gryp0rgfsBVEmKXQQ9hMI1KXCOiesZ2sCl8tRiyJT0CYKgJFW4OzrDVofEng=;
X-YMail-OSG: TGGK7oYVM1nHkIyITcsNHl8uVp0sM4PNdv2noZ7IIwWb9cg
 itBtbc.s9QxPjeUy2.RGc_GA7Xsa7eCXN2gPmgGV7xML6uxtA_oSZZ1YAm79
 iJFkf7H13v_uzsncUIsS7jsJOVpm6I.JfpFAWL_hVjKe_dxhQM29Fx949Ktt
 J8swKhYlQJ_.Gr99et8ZSkdM4tr7v3ItOZDxeDJJTyYNxbz.r3SViASZ54AI
 SErLdPWt3fPYvJSiZJuriBR5c6WrhcCBhR3qY13_hdywkfg7hJcmNjl2P8K5
 zM8SiV19k3XE5Qw7gMZjOrmIKTzEKFyeZxvP_9yf0jvCl_kNZcx3hLKNgQe.
 G2.rNs8u3Kr_CTwI4z0Vdwt1yI_sW09sHBd5lvzwrKOHEMTAa0QdchtK4.9X
 QsWRmcBfC0AQ4GRqKTuzJ2gcc0FFxnr26.Sh9COpts_K7jD7xB6rzct3RbC.
 UEj4u7NM_VegGbMgXkvuICL0LNFgfBIQybnQwdK3BMMIMgPNB4.b0ke0RfhY
 GWSLpcQUmmVm3ZeeevRfv4iN6ZpcjpBw-
X-Rocket-MIMEInfo: 002.001,SGkgR3JlZywKCj5PbiBTYXR1cmRheSwgTWFyY2ggOCwgMjAxNCA5OjAwIFBNLCBHcmVnIEtIIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gd3JvdGU6Cgo.Pk9uIEZyaSwgTWFyIDA3LCAyMDE0IGF0IDA3OjQzOjA0UE0gLTA2MDAsIENoYXNlIFNvdXRod29vZCB3cm90ZToKPj5UaGlzIHBhdGNoIGNoYW5nZXMgYSBoYW5kZnVsIG9mIHdoaWxlIGxvb3BzIHRvIHRpbWVvdXRzIHRvIHByZXZlbnQKPj5pbmZpbml0ZSBsb29waW5nIG9uIGhhcmR3YXJlIGZhaWx1cmUuIEEgY291cGxlIHN1Y2ggbG9vcHMgYXIBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1393922628-27903-1-git-send-email-chase.southwood@yahoo.com> <1394242984-32567-1-git-send-email-chase.southwood@yahoo.com> <20140309030056.GA10867@kroah.com>
Message-ID: <1394337357.59397.YahooMailNeo@web164002.mail.gq1.yahoo.com>
Date: Sat, 8 Mar 2014 19:55:57 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH v3 1/2] Staging: comedi: convert while loops to timeouts in
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20140309030056.GA10867@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

>On Saturday, March 8, 2014 9:00 PM, Greg KH <gregkh@linuxfoundation.org> wrote:

>>On Fri, Mar 07, 2014 at 07:43:04PM -0600, Chase Southwood wrote:
>>This patch changes a handful of while loops to timeouts to prevent
>>infinite looping on hardware failure. A couple such loops are in a
>>function (s626_debi_transfer()) which is called from critical sections,
>>so comedi_timeout() is unusable for them, and an iterative timeout is
>>used instead. For the while loops in a context where comedi_timeout() is
>>allowed, a new callback function, s626_send_dac_eoc(), has been defined
>>to evaluate the conditions that the while loops are testing.  The new
>>callback employs a switch statement based on a simple new enum so that
>>it is usable for all of the different conditions tested in while loops
>>in s626_send_dac().  The proper comedi_timeout() calls are then used.
>
>Your subject seems to be missing a word at the end of it :(

Well what a silly problem to have :( I don't know what happened there
but I'll fix the subject and send it out again.

Thanks,
Chase
