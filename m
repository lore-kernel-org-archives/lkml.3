Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715Ab3GZVhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:37:53 -0400
Received: from mxout1.netvision.net.il ([194.90.9.20]:44087 "EHLO
	mxout1.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760036Ab3GZVhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:37:48 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jul 2013 17:37:48 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <51F2E8A4.2010405@gmail.com>
Date: Sat, 27 Jul 2013 00:22:44 +0300
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the staging tree
References: <20130726160254.83bbe994219d6ee732c64b7d@canb.auug.org.au>
 <20130726210335.GA2788@kroah.com>
In-reply-to: <20130726210335.GA2788@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

I was just about to submit a patch fixing this issue. Should arrive in a 
few minutes. Sorry.

Will this be the follow-on patch you mentioned for fixing the "sparse 
errors" this driver produced? I'm wasn't sure what you meant with that.

Oddly enough, I failed to repeat the compilation issue with allmodconfig 
on x86_64, but it did appear on allyesconfig. The problem is obvious, 
and it's strange my own test compilations went through even so.

Regards,
    Eli

On 27/07/13 00:03, Greg KH wrote:
> On Fri, Jul 26, 2013 at 04:02:54PM +1000, Stephen Rothwell wrote:
>    
>> Hi Greg,
>>
>> After merging the staging tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> drivers/staging/xillybus/xillybus_pcie.o:(.data+0x6d8): multiple definition of `xillyname'
>> drivers/staging/xillybus/xillybus_core.o:(.data+0x888): first defined here
>>
>> Caused by commit 48bae0507410 ("staging: New driver: Xillybus generic
>> interface for FPGA").
>>
>> I have disabled that driver.
>>      
> I think I need to just always make any new staging driver only build as
> a module, and not allowed to be built into the kernel.  That will save
> you time dealing with this, and me the extra time of marking them all as
> modules-only every time :)
>
> Sorry about this, I'll go fix this up now...
>
> greg k-h
>
>    


