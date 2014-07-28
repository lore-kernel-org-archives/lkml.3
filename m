Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003AbaG1QfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:35:05 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:48912
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbaG1QfC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:35:02 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] staging: comedi: amplc_dio200_common: prevent extra
 free_irq()
Thread-Topic: [PATCH 1/3] staging: comedi: amplc_dio200_common: prevent
 extra free_irq()
Thread-Index: AQHPqCrr8EkYQfITLUWKJ+HRxzaKZ5uxGTdAgAOhmICAAPgNUA==
Date: Mon, 28 Jul 2014 16:35:00 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F21646@P3PWEX4MB008.ex4.secureserver.net>
References: <1406308029-15712-1-git-send-email-abbotti@mev.co.uk>
 <1406308029-15712-2-git-send-email-abbotti@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D8825F1E378@P3PWEX4MB008.ex4.secureserver.net>
 <20140727184513.GB29496@kroah.com>
In-Reply-To: <20140727184513.GB29496@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 27, 2014 11:45 AM, Greg Kroah-Hartman wrote:
> On Fri, Jul 25, 2014 at 06:23:10PM +0000, Hartley Sweeten wrote:
>> On Friday, July 25, 2014 10:07 AM, Ian Abbott wrote:
>>> `dio200_detach()` in "amplc_dio200.c" calls
>>> `amplc_dio200_common_detach()` in "amplc_dio200_common.c", followed by
>>> `comedi_legacy_detach()` in "../drivers.c".  Both of those functions
>>> call `free_irq()` if `dev->irq` is non-zero.  The second call produces a
>>> warning message because the handler has already been freed.  Prevent
>>> that by setting `dev->irq = 0` in `amplc_dio200_common_detach()`.
>>>
>>> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
>>>
>> I have already gave a Reviewed-by signoff for this series.
>> 
>> After looking over the code I think a cleaner solution would be to:
>> 
>> 1) Use comedi_legacy_detach() directly for the (*detach) in the
>>    legacy ISA driver.
>> 2) Move the code from amplc_dio200_common_detach() into the
>>    (*detach) function for the PCI driver.
>> 3) Remove the exported function amplc_dio200_common_detach().
>
> So should I not apply these patches?

Greg,

Yes, please apply this series from Ian. It does fix a bug with the
duplicate free_irq().

The comments I gave can be addressed in a later patch.

Sorry for the confusion.
Hartley
