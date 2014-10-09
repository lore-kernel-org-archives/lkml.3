Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaJITCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:02:10 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50074 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751524AbaJITBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:01:53 -0400
Message-ID: <5436DB9A.6040801@hurleysoftware.com>
Date: Thu, 09 Oct 2014 15:01:46 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "xinhui.pan" <xinhuix.pan@intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        mnipxh <mnipxh@gmail.com>, gnomes@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] tty/n_gsm.c: do not clear gsm_mux entry when the gsm
 is not closed
References: <53D0CF0D.9060103@intel.com> <20140727180953.GA7232@kroah.com> <53D5F8C9.4070008@intel.com> <20140728151324.GA12973@kroah.com>
In-Reply-To: <20140728151324.GA12973@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 11:13 AM, Greg Kroah-Hartman wrote:
> On Mon, Jul 28, 2014 at 03:16:25PM +0800, xinhui.pan wrote:
>>> Why can't you do dynamic reference counting of your structure, that
>>> would allow you to get rid of your global array, right?
>>>
>>
>> Thanks for your nice comments.
>> Struct gsm has a ref-count already. :)
> 
> Then you should be fine, no need to keep it in an array.
> 
>> And also adding a ref-count is a little hard to me. :(
>> This global array is used to keep tracking the gsms that stands for the gsmttyXX.
> 
> You shouldn't need that at all, just use a list, you don't care what the
> XX number is within the driver, just allocate a new one with the next
> available number and you should be fine.
> 
>> and it can tell us if we can create a new gsm. :)
> 
> You should always be able to create a new gsm if you need to :)
> 
>> In gsm_init we set *gsm_tty_driver = alloc_tty_driver(256);*
> 
> Why limit to 256?  Just use a list, and a idr structure to allocate the
> minor number, and all should be good.

Hi Greg,

This is still broken in the gsm driver.

As much as I'd like to see someone take ownership of the gsm driver and
do this 'the right way', I think until that happens we should consider
fixing the reuse-while-in-use error.

Would you be willing to take a patch from me that just does the bare
minimum to keep this from panicking in the cdev code?

Regards,
Peter Hurley

