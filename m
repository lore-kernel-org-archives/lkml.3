Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084Ab3LIXft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:35:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38246 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723Ab3LIXfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:35:48 -0500
Message-ID: <52A653C4.1050208@zytor.com>
Date: Mon, 09 Dec 2013 15:35:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>	<alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>	<CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>	<52A6389E.90404@zytor.com> <CAMe9rOpuFzqA7tOGZ3Eh8Vb76+Y5T2xirAfB08NHbSS5R-OjuQ@mail.gmail.com>
In-Reply-To: <CAMe9rOpuFzqA7tOGZ3Eh8Vb76+Y5T2xirAfB08NHbSS5R-OjuQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 01:44 PM, H.J. Lu wrote:
> On Mon, Dec 9, 2013 at 1:39 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 12/09/2013 01:03 PM, H.J. Lu wrote:
>>>
>>> No, please don't do that.  Normally, PIE has zero load address and kernel
>>> can load it anywhere.  There are multiple reasons why PIE has non-zero
>>> load address.  Saying you need to load a program above 4GB under x86-64,
>>> you can't do that with normal dynamic executable.  PIE with non-zero load
>>> address is the only way to do that on x86-64.
>>>
>>
>> Why does it have to be PIE?
>>
> 
> x86-64 small model is limited to 4GB in size.  You can't build
> a dynamic executable in small model larger than 4GB.
> 
> There are medium and large models.  But they are slower than
> small models as well as small models in PIE.  Also there are
> no glibc run-times for medium and large models.
> 

Compiling for the small PIC model shouldn't automatically mean
generating a PIE (ET_DYN) executable, though (and if those are
inherently linked, that is a fundamental bug IMNSHO.)

	-hpa

