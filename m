Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3DXQ5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 12:57:01 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49617 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756574Ab3DXQ5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 12:57:00 -0400
Message-ID: <51780EDA.3000003@sgi.com>
Date: Wed, 24 Apr 2013 09:56:58 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Bian LuLu <helianthus.lu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [RFC] The meaning of local_cpulist and local_cpus
References: <CAG82n_ni9ZAThGbMfqqObnz7QyQpH18G4hYBLt+BdeRHPE6EBg@mail.gmail.com> <CAErSpo5VaiuH+WT4RdM9yU9AHMkUKzATMiNzhixRU04_aZusBg@mail.gmail.com>
In-Reply-To: <CAErSpo5VaiuH+WT4RdM9yU9AHMkUKzATMiNzhixRU04_aZusBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 4/24/2013 9:48 AM, Bjorn Helgaas wrote:
> [+cc linux-pci, Mike]
> 
> On Wed, Apr 24, 2013 at 4:06 AM, Bian LuLu <helianthus.lu@gmail.com> wrote:
>> Hi all,
>>
>> Recently, i read some codes of PCI portions. I think
>> local_cpulist is a list about one kind of CPU and
>> local_cpus is a mask of CPU. But i am not sure when
>> and how i should use these two parameters.
>>
>> See http://lxr.linux.no/linux+v3.5.4/drivers/pci/pci-sysfs.c#L390 for
>> details.
>>
>> Would anyone please give me some suggestions?
>> Thanks in advance ;-)
> 
> I don't know off-hand, but maybe Mike or somebody on linux-pci does.
> It looks like Mike added local_cpulist with 39106dcf85.
> 

It primarily comes into play when you have a large # of cpus.
Here's the difference on a system that has 1024 cpu threads:

harp31-sys:/sys/devices/system/node/node20 # cat cpulist
160-167,672-679
harp31-sys:/sys/devices/system/node/node20 # cat cpumap
00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,000000ff,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,00000000,00000000,
00000000,00000000,00000000,00000000,00000000,000000ff,00000000,
00000000,00000000,00000000,00000000

Which is easier to interpret?  :)

But there are some older user side utilities that still
use the mask format.
