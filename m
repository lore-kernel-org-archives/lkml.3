Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3EULCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 07:02:24 -0400
Received: from mxout4.netvision.net.il ([194.90.9.27]:42871 "EHLO
	mxout4.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3EULCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 07:02:23 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2013 07:02:23 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <519B506C.6070400@gmail.com>
Date: Tue, 21 May 2013 13:46:04 +0300
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH v4 1/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
References: <1368802420-26723-1-git-send-email-eli.billauer@gmail.com>
 <20130520211631.GA18956@local>
In-reply-to: <20130520211631.GA18956@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/13 00:16, Hans J. Koch wrote:
> On Fri, May 17, 2013 at 05:53:39PM +0300, Eli Billauer wrote:
>    
>> It has turned out somewhat tricky to put Xillybus in one of the existing
>> categories of device drivers. I placed it under drivers/uio, mainly because it
>> shares the spirit of a generic driver allowing userspace programs to talk
>> directly with hardware. Unlike the classic UIO devices, Xillybus' char files
>> shouldn't be memory mapped, but rather used in the regular manner as streams
>> of data.
>>      
> In that case it simply isn't a UIO device.
>
>    
By moving Xillybus to drivers/uio, I suggested that the term UIO could 
mean any direct user-space I/O, not just by memory mapping. But hint was 
taken. I'll move it back to drivers/misc. Unless someone can suggest a 
better place.
>> This driver was previously posted under drivers/misc/. The misc device
>> framework turned out to be inadequate, as the driver may create more than 100
>> device files in some cases.
>>      
> And that is a problem? If yes, try something else like sysfs. From your
> description, this is a drivers/misc device for me.
>    
Sysfs has been suggested in the past. My best understanding of sysfs is 
that it's there to convey small pieces of information. Xillybus' device 
files are intended for possibly heavy data traffic.

Thanks for your inputs.
    Eli

