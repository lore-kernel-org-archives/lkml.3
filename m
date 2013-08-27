Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3H0Sa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:30:26 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:46207 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3H0SaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:30:25 -0400
MIME-Version: 1.0
In-Reply-To: <1377627362.6337.40.camel@joe-AO722>
References: <7f53397d0aa93e644124037d44188da5067336fc.1377614854.git.d.kasatkin@samsung.com>
	<1377620432.6337.12.camel@joe-AO722>
	<521CE2C9.1010002@akamai.com>
	<1377627362.6337.40.camel@joe-AO722>
Date: Tue, 27 Aug 2013 21:30:24 +0300
Message-ID: <CACE9dm_msF7e2aKEeT0J6maxnka1NpaAbTWTp5r1MbpDHSw4Kg@mail.gmail.com>
Subject: Re: [PATCHv2 1/2] dev-core: fix build break when DEBUG is enabled
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@akamai.com>, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 9:16 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2013-08-27 at 13:32 -0400, Jason Baron wrote:
>> On 08/27/2013 12:20 PM, Joe Perches wrote:
>> > On Tue, 2013-08-27 at 17:47 +0300, Dmitry Kasatkin wrote:
>> >> When DEBUG is defined, dev_dbg_ratelimited uses dynamic debug data
>> >> structures even when CONFIG_DYNAMIC_DEBUG is not defined.
>> >> It leads to build break.
>> >> For example, when I try to use dev_dbg_ratelimited in USB code and
>> >> CONFIG_USB_DEBUG is enabled, but CONFIG_DYNAMIC_DEBUG is not, I get:
>> > Jason?
>> >
>> > Seems mostly sensible to me but I think the first check
>> > needs to be
>> >
>> > #if defined(CONFIG_DYNAMIC_DEBUG) && defined(DEBUG)
>>
>> Why? All the other call-sites, do it the way Dmitry has done it.
>

I followed the pattern..

> Fine.  Originally I thought it useful to not
> store the ratelimit state, but this way those
> messages can be enabled via the dynamic_debug
> control.
>

Indeed.

Thanks.

- Dmitry

-- 
Thanks,
Dmitry
