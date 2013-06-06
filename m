Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3FFQPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:15:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39059 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3FFQLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:11:18 -0400
Message-ID: <51B0B4A2.4010104@wwwdotorg.org>
Date: Thu, 06 Jun 2013 10:11:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Olof Johansson <olof@lixom.net>, "gnurou@gmail.org" <gnurou@gmail.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] simplefb: add support for a8b8g8r8 pixel format
References: <1370503259-16618-1-git-send-email-acourbot@nvidia.com> <3356BC4D-EEF6-4FCA-9310-5B0727EBF288@jcrosoft.com> <51B0446A.4090305@nvidia.com>
In-Reply-To: <51B0446A.4090305@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 02:12 AM, Alex Courbot wrote:
> On 06/06/2013 04:59 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>
>> On Jun 6, 2013, at 9:20 AM, Alexandre Courbot <acourbot@nvidia.com>
>> wrote:
>>
>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

No commit description? It'd be useful to at least justify this by
mentioning that some platform will actually use this...

...
>>> static struct simplefb_format simplefb_formats[] = {
>>>     { "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
>>> +    { "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {31, 8} },
>>
>> why don't you parse the string?
>>
>> so you will a real generic bindings
> 
> Tried that already, got NACKed: https://lkml.org/lkml/2013/5/27/330
> 
> The list of modes of this driver should not grow too big. Even in terms
> of footprint I'd say the list should remain smaller than the parsing code.
> 
> What we can discuss though is whether we want to keep this a8b8g8r8
> syntax or switch to something more standard, say "rgba8888".

I would prefer to keep the syntax of the new formats consistent, so that
if we ever do add format-parsing code rather than table-based lookup,
all the existing formats will continue to work unchanged, without any
kind of fallback lookup table.
