Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3F1KDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:03:15 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:42922 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab3F1KDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:03:13 -0400
MIME-Version: 1.0
In-Reply-To: <51CB5176.5000404@wwwdotorg.org>
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com>
	<1372112849-670-2-git-send-email-dh.herrmann@gmail.com>
	<51CB5176.5000404@wwwdotorg.org>
Date: Fri, 28 Jun 2013 12:03:11 +0200
Message-ID: <CANq1E4TScD2EvGS-nah=QACV+JmxYhYQRNVdRe8TSZzJD6UJ7w@mail.gmail.com>
Subject: Re: [RFC 1/6] fbdev: simplefb: add init through platform_data
From: David Herrmann <dh.herrmann@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Jun 26, 2013 at 10:39 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/24/2013 04:27 PM, David Herrmann wrote:
>> If we create proper platform-devices in x86 boot-code, we can use simplefb
>> for VBE or EFI framebuffers, too. However, there is normally no OF support
>> so we introduce a platform_data object so x86 boot-code can pass the
>> paramaters via plain old platform-data.
>>
>> This also removes the OF dependency as it is not needed. The headers
>> provide proper dummies for the case OF is disabled.
>>
>> Furthermore, we move the FORMAT-definitions to the common platform header
>> so initialization code can use it to transform "struct screen_info" to
>> the right format-name.
>
>> diff --git a/include/linux/platform_data/simplefb.h b/include/linux/platform_data/simplefb.h
>
>> +/* the framebuffer size and location is available as IORESOURCE_MEM */
>> +struct simplefb_platform_data {
>> +     u32 width;
>> +     u32 height;
>> +     u32 stride;
>> +     char format[64];
>> +};
>
> Any reason not to make format:
>
> const char *format;
>
> You should be able to initialize that just as easily in platform code,
> either as static data or at runtime, I think.

That makes sense. I fixed it up.

Thanks
David
