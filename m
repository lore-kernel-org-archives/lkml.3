Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3LSPmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:42:22 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:54411 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab3LSPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:42:20 -0500
Message-ID: <52B313D8.6090508@linux.com>
Date: Thu, 19 Dec 2013 16:42:16 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 21/38] workqueue: add missing put_device call
References: <1387465429-3568-2-git-send-email-levex@linux.com>	<1387465429-3568-22-git-send-email-levex@linux.com>	<20131219152044.GB16994@htj.dyndns.org>	<52B31158.3030801@linux.com> <CAOS58YO7Ot69kv=2UOTDORMAtgL2EOq-voEj3JLCDb8Rv=LABA@mail.gmail.com>
In-Reply-To: <CAOS58YO7Ot69kv=2UOTDORMAtgL2EOq-voEj3JLCDb8Rv=LABA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+Cc Greg]

On 12/19/2013 04:34 PM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Dec 19, 2013 at 10:31 AM, Levente Kurusa <levex@linux.com> wrote:
>> The reason I removed the kfree() was because the put_device() will decrement
>> wq_dev->dev's reference count to zero (it is set to one by device_register) and hence the
>> wq_device_release() will be called. Now, this effectively does the same the kfree() call
>> would have done but also driver core is notified.
> 
> Yeah, I know it does the same thing. It's just not the right way to do it.
> 
>> Also, if you take a look at the comment for the device_register() function, it explicitly
>> says NOT to kfree the struct device, but instead call put_device() and let the device's release()
>> function take care.
> 
> Greg, the API as described by the comment is really weird and
> unconventional. Failed calls are not supposed to have side effects
> which require explicit cleanup. Can we please update the comment?
> 

Yes, it was already discussed that it would be more sane to have
device_register() call put_device() if it would fail, but Greg
said that the API was designed so that no kfree()s happen in the core.

-- 
Regards,
Levente Kurusa
