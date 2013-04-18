Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967001Ab3DRQtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:49:10 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:51514 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965490Ab3DRQtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:49:09 -0400
Message-ID: <517023F8.5050606@gmail.com>
Date: Thu, 18 Apr 2013 12:48:56 -0400
From: Kyle Evans <kvans32@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130220 Thunderbird/17.0.3
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: BUG: Fn keys not working on EliteBook 8460p after fabf85e3ca15d5b94058f391dac8df870cdd427a
References: <201304130331.18301@pali> <1365816906.13667.6.camel@x230.lan>     <51695169.6090306@gmail.com> <1365870087.13667.7.camel@x230.lan>    <51699843.7060905@gmail.com> <1366129583.13667.11.camel@x230.lan>   <516EC19C.3010906@gmail.com> <1366221554.13667.13.camel@x230.lan>  <516FFB3D.3060002@gmail.com> <1366300697.13667.15.camel@x230.lan>
In-Reply-To: <1366300697.13667.15.camel@x230.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/18/2013 11:58 AM, Matthew Garrett wrote:
> On Thu, 2013-04-18 at 09:55 -0400, Kyle Evans wrote:
>
>> 0x9(write), or SHKS, is essentially ec_write(SFHK,Arg0). Arg0 turns out
> Oh - try changing
>
> int query = 1
>
> to
>
> int query=0x6e
>
That only works if I also change:

-#define HPWMI_BIOS_QUERY 0x8
+#define HPWMI_BIOS_QUERY 0x9

But then we are still faced with a hardware detection problem I would assume.

