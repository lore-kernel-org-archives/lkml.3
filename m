Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab3LDSjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:39:14 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:42198 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab3LDSjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:39:12 -0500
Message-ID: <529F76CB.8080601@linux.com>
Date: Wed, 04 Dec 2013 19:39:07 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        EDAC <linux-edac@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
References: <5298F900.9000208@linux.com> <20131129205628.GA20144@pd.tnic> <52999419.7040600@linux.com> <20131130111214.GB4323@pd.tnic> <20131203022330.GA25136@gchen.bj.intel.com> <20131203170150.GA5369@pd.tnic> <20131204073824.GA22134@gchen.bj.intel.com>
In-Reply-To: <20131204073824.GA22134@gchen.bj.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-12-04 08:38, Chen, Gong:
> On Tue, Dec 03, 2013 at 06:01:50PM +0100, Borislav Petkov wrote:
>> Date: Tue, 3 Dec 2013 18:01:50 +0100
>> From: Borislav Petkov <bp@alien8.de>
>> To: "Chen, Gong" <gong.chen@linux.intel.com>
>> Cc: Levente Kurusa <levex@linux.com>, Ingo Molnar <mingo@kernel.org>,
>>  Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>, "H.
>>  Peter Anvin" <hpa@zytor.com>, x86@kernel.org, EDAC
>>  <linux-edac@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
>> Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
>> User-Agent: Mutt/1.5.21 (2010-09-15)
>>
>> Can you please fix your
>>
>> Mail-Followup-To:
>>
>> header? It is impossible to reply to your emails without fiddling with
>> the To: and Cc: by hand which gets very annoying over time.
> 
> I add some configs in my muttrc. Hope it works.
> 
>>
>> On Mon, Dec 02, 2013 at 09:23:30PM -0500, Chen, Gong wrote:
>>> I have some concerns about it. if device_register is failed, it will
>>> backtraces all kinds of conditions automatically, including put_device
>>> definately. So do we really need an extra put_device when it returns
>>> failure?
>>
>> Do you mean the "done:" label in device_add() which does put_device()
>> and which gets called by device_register()?
>>
> 
> Not only. I noticed that another put_device under label "Error:".
> 

That label is called when we failed to add the kobject to its parent.
It just puts the parent of the device. I don't think it has anything
to do with us put_device()-ing the actual device too.

-- 
Regards,
Levente Kurusa
