Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbaC0OzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 10:55:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57692 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbaC0Oy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 10:54:57 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>, Peter Hurley <peter@hurleysoftware.com>
CC: Tony Lindgren <tony@atomide.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "b32955@freescale.com" <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 10/11] Revert "serial: omap: unlock the port lock"
Thread-Topic: [PATCH 10/11] Revert "serial: omap: unlock the port lock"
Thread-Index: AQHPSW4hDa4trLKNAUWvqoFzAiyHY5r1BOvA
Date: Thu, 27 Mar 2014 14:54:49 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7046EF530@DFLE11.ent.ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
 <1395343807-21618-10-git-send-email-balbi@ti.com>
 <20140325182856.GA31906@atomide.com> <5333732F.6040803@hurleysoftware.com>
 <20140327021043.GB11651@saruman.home> <53338C81.3060600@hurleysoftware.com>
 <20140327033724.GB13038@saruman.home>
In-Reply-To: <20140327033724.GB13038@saruman.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Balbi, Felipe
>Sent: Wednesday, March 26, 2014 11:37 PM
>To: Peter Hurley
>Cc: Balbi, Felipe; Tony Lindgren; Greg KH; linux-serial@vger.kernel.org; linux-
>bluetooth@vger.kernel.org; Karicheri, Muralidharan; b32955@freescale.com; Linux OMAP
>Mailing List; Linux Kernel Mailing List
>Subject: Re: [PATCH 10/11] Revert "serial: omap: unlock the port lock"
>
>Hi,
>
>On Wed, Mar 26, 2014 at 10:27:13PM -0400, Peter Hurley wrote:
>> On 03/26/2014 10:10 PM, Felipe Balbi wrote:
>> >Hi,
>> >
>> >On Wed, Mar 26, 2014 at 08:39:11PM -0400, Peter Hurley wrote:
>> >>On 03/25/2014 02:28 PM, Tony Lindgren wrote:
>> >>>* Felipe Balbi <balbi@ti.com> [140320 12:39]:
>> >>>>This reverts commit 0324a821029e1f54e7a7f8fed48693cfce42dc0e.
>> >>>>
>> >>>>That commit tried to fix a deadlock problem when using hci_ldisc,
>> >>>>but it turns out the bug was in hci_ldsic all along where it was
>> >>>>calling ->write() from within
>> >>>>->write_wakeup() callback.
>> >>>>
>> >>>>The problem is that ->write_wakeup() was called with port lock
>> >>>>held and ->write() tried to grab the same port lock.
>> >>>
>> >>>Should this and the next patch be earlier in the series as a fix
>> >>>for the v3.15-rc cycle? Should they be cc: stable as well?
>> >>
>> >>Well, right now the other fix has had _zero_ testing so not really a
>> >>-stable candidate just yet.
>> >
>> >how can you even say that ?
>>
>> I misunderstood when you wrote:
>>
>> On 03/20/2014 02:11 PM, Felipe Balbi wrote:
>> > here's a build-tested only patch which is waiting for testing from
>> > other colleagues who've got a platform to reproduce the problem:
>>
>> and then the version I reviewed had no Tested-by: tags.
>
>I wouldn't add that tag myself, but Murali (in Cc) did help testing together with other

Yes. One of our customer did the test as the problem was reported by the
customer. The deadlock fix patch from Balbi (hci_ldsic) fixed the issue 
and customer confirmed that the issue is fixed.

Murali

>colleagues.
>
>> >How else would we have found the issue to start with ?
>>
>> Bug report?
>
>touchè :-)
>
>--
>balbi
