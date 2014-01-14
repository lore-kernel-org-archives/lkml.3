Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaANIBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:01:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:18153 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbaANIBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:01:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,657,1384329600"; 
   d="scan'208";a="466284392"
From: "Xiong, Jinshan" <jinshan.xiong@intel.com>
To: Monam Agarwal <monamagarwal123@gmail.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: Re: [PATCH v3 1/2] Staging: lustre: Refactor the function
 interval_erase_color() in /lustre/ldlm/interval_tree.c
Thread-Topic: [PATCH v3 1/2] Staging: lustre: Refactor the function
 interval_erase_color() in /lustre/ldlm/interval_tree.c
Thread-Index: AQHPDrx3sm68dCmYlUWiSUPuqtgDVZqEZl2A
Date: Tue, 14 Jan 2014 08:01:44 +0000
Message-ID: <8485C2C1-AAC7-404D-9AB0-51E3ED763C0F@intel.com>
References: <20140111203358.GA6501@kroah.com>
 <0E07CEA6-D544-4809-A0DC-48DCB808669D@intel.com>
In-Reply-To: <0E07CEA6-D544-4809-A0DC-48DCB808669D@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.225.130]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <BFF2FB03270FD3469937A7755602DAB3@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 13, 2014, at 11:56 PM, Dilger, Andreas <andreas.dilger@intel.com> wrote:

> 
> 
> Begin forwarded message:
> 
>> From: Greg KH <gregkh@linuxfoundation.org>
>> Subject: Re: [PATCH v3 1/2] Staging: lustre: Refactor the function interval_erase_color() in /lustre/ldlm/interval_tree.c
>> Date: January 11, 2014 at 1:33:58 PM MST
>> To: Monam Agarwal <monamagarwal123@gmail.com>
>> Cc: Dan Carpenter <dan.carpenter@oracle.com>, <devel@driverdev.osuosl.org>, <andreas.dilger@intel.com>, <peter.p.waskiewicz.jr@intel.com>, <linux-kernel@vger.kernel.org>, Rashika Kheria <rashika.kheria@gmail.com>
>> 
>> On Sat, Jan 11, 2014 at 05:14:35PM +0530, Monam Agarwal wrote:
>>> On Sat, Jan 11, 2014 at 5:09 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>>>> On Sat, Jan 11, 2014 at 04:56:44PM +0530, Monam Agarwal wrote:
>>>>> I took n as a flag to decide whether parent->in_left == node is true
>>>>> or not in the called function.
>>>> 
>>>> So "n" stands for "node"?
>>>> 
>>>>> Should I use some other name for the flag.
>>>> 
>>>> 
>>>> Yes.
>>>> 
>>> 
>>> Will "flag" be a suitable name?

I’d suggest `bool is_right_child’.

I’ve checked the patch and it looks good. There exists a unit test case for interval tree under lustre/tests/ named it_test.c, please compile it and verify your change.

Jinshan

>> 
>> Ick, no.  You don't want a "flag" to have to determine what the logic is
>> for a given function.  That just causes confusion and makes things
>> really hard to read and understand over time.
>> 
>> This whole function looks like a red/black tree, or something like that.
>> Shouldn't we just be using the in-kernel implementation of this?  And if
>> not, then you really need to get the feedback of the code's original
>> authors as you might be changing the algorithm in ways that could cause
>> big problems.
>> 
>> thanks,
>> 
>> greg k-h
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Lustre Software Architect
> Intel Corporation
> 
> 
> 
> 
> 
> 

