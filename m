Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3BAOvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 09:51:55 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65278 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab3BAOvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 09:51:53 -0500
MIME-Version: 1.0
In-Reply-To: <1470501.uiZyX6kBKo@donald.sf-tec.de>
References: <20130131200110.GA6032@p100.box> <1359668524.2468.12.camel@dabdike>
 <510AE623.7000609@zytor.com> <1470501.uiZyX6kBKo@donald.sf-tec.de>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 1 Feb 2013 14:51:30 +0000
X-Google-Sender-Auth: cK_U80AAFUcuzFUoY_iU3rPLJZg
Message-ID: <CAHkRjk5TC+iqdJxJu1N5D-nMkb=UTff7dBVzSpdxoLMF0uN29Q@mail.gmail.com>
Subject: Re: [PATCH] parisc: unbreak automounter support on 64-bit kernel with
 32-bit userspace
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>,
        autofs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 January 2013 22:10, Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
> H. Peter Anvin wrote:
>> On 01/31/2013 01:42 PM, James Bottomley wrote:
>> > On Thu, 2013-01-31 at 13:29 -0800, H. Peter Anvin wrote:
>> >> On 01/31/2013 12:26 PM, James Bottomley wrote:
>> >>> [adding autofs list and maintainer for their perusal and ack, although
>> >>> this is an obvious fix to me
>> >>>
>> >>> James]
>> >>
>> >> The #if list probably should be inverted, and only specific platforms
>> >> should have unsigned long...
>> >
>> > The whitelist is 64 bit only platforms, like ia64, isn't it?  So yes,
>> > they're far less numerous.
>>
>> Correct.  It is basically the 64-bit platforms without any 32-bit
>> userspace, like Alpha and IA64.
>
> Arm64?

It supports 32-bit user-space (CONFIG_COMPAT). But we missed this
#ifdef for arm64. I'm not familiar with the autofs subsystem but at a
first look it seems that autofs_wqt_t types are not shared with user
space as part of a structure. It can come as an argument for an ioctl
command but as long as we don't expect this type to hold data larger
than 32-bit it should be ok.

-- 
Catalin
