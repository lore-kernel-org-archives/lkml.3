Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab3CSCIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:08:22 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:47194 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3CSCIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:08:21 -0400
Date: Tue, 19 Mar 2013 10:08:11 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, shangw@linux.vnet.ibm.com,
        linuxram@us.ibm.com
Subject: Re: [PATCH 1/2] driver core: remove device_add_attrs() in
 drivers/base/bus.c
Message-ID: <20130319020811.GA10936@weiyang.vnet.ibm.com>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1362622966-20003-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <1362622966-20003-2-git-send-email-weiyang@linux.vnet.ibm.com>
 <20130319001822.GC13502@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130319001822.GC13502@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031902-9574-0000-0000-000007185B9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 05:18:22PM -0700, Greg KH wrote:
>On Thu, Mar 07, 2013 at 10:22:45AM +0800, Wei Yang wrote:
>> Originally, we have two functions named device_add_attrs() in
>> drivers/base/bus.c and drivers/base/core.c. This will cause some confusion
>> when reading the code.
>
>Why?  It's just static functions.

Hmm, yes, they are static functions.

The confusion comes from myself. When I look for the definitions of the
function in cscope, it pop out two line with the same name. So I just think
whether we can help the reader, if there is only one pop up.

Well, I have to admit this is my personal feeling and due to my lack of
experence.

>
>> And the one in drivers/base/bus.c do the same action as device_add_attributes()
>> in drivers/base/core.c. That would be better to reuse this code.
>
>Possibly, yes, but you put the .h entry in the wrong place, thereby
>exposing a previously static function to the entire kernel, which is not

Agree, this is not a good idea to expose an extra interface to the entire
kernel.

>good at all.  Why did you do that?  Are you now going to want to call
>that function from some driver?

The reason for this patch is, the logic in these two functions are the same.
My purpose is to reuse the code and save some space for the kernel image,
well, I have to admit it is just a very small piece of space.

>
>greg k-h

-- 
Richard Yang
Help you, Help me

