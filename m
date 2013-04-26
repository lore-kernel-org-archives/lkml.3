Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab3DZUxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 16:53:35 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:57925 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab3DZUxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 16:53:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVEQO-dLJRjn9Z7JgwGWAn1M8S1Tn2_V0Fq+6kB0rG=Bg@mail.gmail.com>
References: <1366940841-15370-1-git-send-email-yinghai@kernel.org>
 <CAErSpo5zfHR-agNBdgqfVjCU+-KcTZV+1bvML5Uw-+icDqzzEA@mail.gmail.com> <CAE9FiQVEQO-dLJRjn9Z7JgwGWAn1M8S1Tn2_V0Fq+6kB0rG=Bg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 26 Apr 2013 14:53:09 -0600
Message-ID: <CAErSpo7DUDQ_XgVKAfWxqYJA=q85ps46bffV-4a7b0vOzAP5DA@mail.gmail.com>
Subject: Re: [PATCH] PCI: Fix racing for pci device removing via sysfs
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 2:20 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Apr 26, 2013 at 9:28 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> This is a gross hack.  Iterating through all known pci_devs to see if
>> this one still exists?
>>
>> I reproduced the original problem, applied this patch, and verified
>> that it avoids the original crash.
>>
>> However, it's still incorrect because now you're looking at pdev after
>> it's been freed. With CONFIG_SLUB_DEBUG_ON=y, the removal still causes
>> a crash in remove_callback().
>>
>
> Yes, there is small window, that could have bus and dev get freed...
>
> Please check attached that should address your concerns.

You can't be serious.  This is a disgusting mess.  Checking a list
pointer for LIST_POISON1?  As far as I'm concerned, this is a waste of
my time.

Bjorn
