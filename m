Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965752Ab3DRNzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:55:23 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:53700 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935511Ab3DRNzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:55:21 -0400
Message-ID: <516FFB3D.3060002@gmail.com>
Date: Thu, 18 Apr 2013 09:55:09 -0400
From: Kyle Evans <kvans32@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130220 Thunderbird/17.0.3
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: BUG: Fn keys not working on EliteBook 8460p after fabf85e3ca15d5b94058f391dac8df870cdd427a
References: <201304130331.18301@pali> <1365816906.13667.6.camel@x230.lan>    <51695169.6090306@gmail.com> <1365870087.13667.7.camel@x230.lan>   <51699843.7060905@gmail.com> <1366129583.13667.11.camel@x230.lan>  <516EC19C.3010906@gmail.com> <1366221554.13667.13.camel@x230.lan>
In-Reply-To: <1366221554.13667.13.camel@x230.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/17/2013 01:59 PM, Matthew Garrett wrote:
> On Wed, 2013-04-17 at 11:37 -0400, Kyle Evans wrote:
>> On 04/16/2013 12:26 PM, Matthew Garrett wrote:
>>> Can you try this patch?
>>>
>> No dice. I have a dmi check patch that I will send in a day or two if
>> you don't find what you are looking for.
> DMI's almost certainly the wrong solution. According to your DSDT, EC
> register 0xe6 is called SFHK. That's written to by the SSHK method,
> which in turn is executed by SHKS which should be called by the
> hp_wmi_query call added there. Any chance you can try to figure out why
> that's not happening?
>

I am not fully understanding how the bios query ID gets translated into 
the method. As far as I can tell this happens under HWMC. But, if I 
trace through that, 0x8(write) and 0x9(read) do not exist. However, 
0x9(read) does have a method that works when I query it, GHKS. I do not 
find the method for 0x8(write).

0x9(write), or SHKS, is essentially ec_write(SFHK,Arg0). Arg0 turns out 
to be whatever data is sent in the 0x9 buffer.
                                 ...
                                 CreateDWordField (Arg1, 0x10, DDWD)

                                 If (LEqual (CMDT, 0x09))
                                 {
                                     Store (SHKS (DDWD), Local2)
                                 ...

I tried writing 0x60, and I tried writing 0x0e just to see if it if a 
subset of that register is needed to enable the keys and it seems I need 
the full 0x6e. I only find two places in the DSDT with that value, both 
in the WQAE buffer and I can't see how that is used.
